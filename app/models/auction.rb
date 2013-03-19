class Auction < ActiveRecord::Base
  extend Enumerize
  
  include Categories
  
  AUCTION_FEES = {
    :min => 0.1,
    :max => 35.0,
    :fair => 0.03,
    :default => 0.06
  }
  
  searchable :unless => :template? do
    text :title, :boost => 5.0, :stored => true
    text :content
    boolean :fair
    boolean :ecologic
    boolean :small_and_precious
    boolean :active
    string :condition
    integer :category_ids, :references => Category, :multiple => true
  end
  
  # Indexing via Delayed Job Daemon
  handle_asynchronously :solr_index, queue: 'indexing', priority: 50
  handle_asynchronously :solr_index!, queue: 'indexing', priority: 50

  def remove_from_index_with_delayed
    Delayed::Job.enqueue RemoveIndexJob.new(record_class: self.class.to_s, attributes: self.attributes), queue: 'indexing', priority: 50
  end
  alias_method_chain :remove_from_index, :delayed
  
  # refs #128
  default_scope where(:auction_template_id => nil)
  
  # Dont search for inactive auctions
  default_scope where(:active => true)

  before_validation :sanitize_content, :on => :create
  before_validation :set_expire_in_pioneer_version, :on => :create
 
  validates_presence_of :transaction

  validates_presence_of :expire
  #validate :validate_expire
  
  after_initialize :initialize_values
  
  def initialize_values
    begin
    self.quantity ||= 1
    self.price ||= 1
    self.friendly_percent ||= 0
    self.active = false if self.new_record?
    self.locked = false if self.new_record?
    # Auto-Completion raises MissingAttributeError: 
    # http://www.tatvartha.com/2011/03/activerecordmissingattributeerror-missing-attribute-a-bug-or-a-features/
    rescue ActiveModel::MissingAttributeError
    end
  end
  
  ##### commendation
  ## fair
  
  validates_presence_of :fair_kind, :if => :fair?
  
  before_validation :delete_fair_kind_unless_fair
  def delete_fair_kind_unless_fair
    self.fair_kind = nil unless fair?
  end
  
  enumerize :fair_kind, :in => [:fair_seal, :fair_trust, :social_producer]
  
  validates_presence_of :fair_seal, :if => lambda {|obj| obj.fair_kind == "fair_seal"}
  enumerize :fair_seal, :in => [:trans_fair, :weltladen, :wtfo], :default => :trans_fair
  
  ### fair trust questionnaire
  has_one :fair_trust_questionnaire, :dependent => :destroy
  accepts_nested_attributes_for :fair_trust_questionnaire
  validates_associated :fair_trust_questionnaire, :if => lambda {|obj| obj.fair_kind == "fair_trust"}
  
  before_validation :remove_fair_trust_questionnaire_unless_required
  
  def remove_fair_trust_questionnaire_unless_required
    self.fair_trust_questionnaire = nil unless self.fair_kind == "fair_trust"
  end
  
  ### social producer questionnaire
  has_one :social_producer_questionnaire, :dependent => :destroy
  accepts_nested_attributes_for :social_producer_questionnaire
  validates_associated :social_producer_questionnaire, :if => lambda {|obj| obj.fair_kind == "social_producer"}
  
  before_validation :remove_social_producer_questionnaire_unless_required
  
  def remove_social_producer_questionnaire_unless_required
    self.social_producer_questionnaire = nil unless self.fair_kind == "social_producer"
  end
  
  ## ecologic
  
  validates_presence_of :ecologic_seal, :if => :ecologic?
  enumerize :ecologic_seal, :in => [:bio_siegel, :eg_bio_siegel, :ecovin, :naturland, :gaea_e_v_oekologischer_landbau, :biokreis, :bioland, :biopark, :demeter, :europaeisches_umweltzeichen, :gots, :textiles_vertrauen_nach_oeko_tex_standard_100plus, :ivn_zertifiziert_naturtextil, :ivn_zertifiziert_naturtextil_best, :rainforest_alliance, :der_blaue_engel, :deutsches_gueteband_wein, :ecogarantie, :fsc_pure_papier, :fsc_pure_holz, :greenline, :gut, :kork_logo, :kompostierbar_compostable, :kontrollierte_natur_kosmetik_bdih, :natrue_natural_cosmetics_with_organic_portion, :natrue_organic_cosmetics, :natureplus, :oeko_control, :tco_certified, :utz_certified, :tuev_eco_kreis]
  
  ## small_and_precious
  validates_presence_of :small_and_precious_edition, :if => :small_and_precious?
  validates_numericality_of :small_and_precious_edition, :greater_than => 0, :if => :small_and_precious?
  validates_presence_of :small_and_precious_reason, :if => :small_and_precious?
  
  ## friendly percent
  
  validates_numericality_of :friendly_percent, :greater_than_or_equal_to => 0.0, :less_than_or_equal_to => 99.0, :only_integer => true
  enumerize :friendly_percent_organisation, :in => [:transparency_international], :default => :transparency_international
  validates_presence_of :friendly_percent_organisation, :if => :friendly_percent
    
    
  ## -------------- Calculate Fees And Donations ---------------
  
  # Fees and donations
  monetize :calculated_corruption_cents
  monetize :calculated_friendly_cents
  monetize :calculated_fee_cents
  
private  
    
  def friendly_percent_result
    if self.friendly_percent
      self.price * (self.friendly_percent / 100.0)
    else
      Money.new(0)
    end
  end
  
  ## fees and donations
  
  def corruption_percentage
    0.01
  end
  
  def corruption_percent_result
    self.price * corruption_percentage
  end
  
  
  def fee_percentage
    if fair?
      AUCTION_FEES[:fair]
    else
      AUCTION_FEES[:default]
    end
  end
  
  def fee_result
    r = self.price * fee_percentage
    min = Money.new(AUCTION_FEES[:min]*100)
    r = min if r < min
    max = Money.new(AUCTION_FEES[:max]*100)
    r = max if r > max
    r
  end

public
  
  def friendly_percent_calculated
    friendly_percent_result
  end
  
  def calculated_fees_and_donations
    self.calculated_corruption + self.calculated_friendly + self.calculated_fee
  end
    
  def calculate_fees_and_donations
    self.calculated_corruption  = corruption_percent_result
    self.calculated_friendly = friendly_percent_result
    self.calculated_fee = fee_result
  end  
    
  # --------------------------------  
    
  # other
  
  def validate_expire
    return false unless self.expire
    if self.expire < 1.hours.from_now
      self.errors.add(:expire, "Expire time must be at least one hour in the future.")
    return false
    end
    if self.expire > 1.years.from_now
      self.errors.add(:expire, "Expire time must less than one year from now.")
    return false
    end
    return true
  end

  
  acts_as_followable

  enumerize :condition, :in => [:new, :old]
  enumerize :color, :in => [:white, :black, :yellow, :orange, :red, :green, :blue, :turquoise, :brown, :violet, :grey, :multicolored]   
  validates_length_of :size, :maximum => 4
  validates_presence_of :quantity
  validates_numericality_of :quantity, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 10000

  monetize :price_cents
    
  serialize :transport, Array
  enumerize :transport, :in => [:pickup, :insured, :uninsured], :multiple => true 
  validates :transport, :size => 1..-1
  validates_presence_of :transport_details
  
  serialize :payment, Array
  enumerize :payment, :in => [:bank_transfer, :cash, :paypal, :cach_on_delivery, :invoice], :multiple => true
  validates :payment, :size => 1..-1
  validates_presence_of :payment_details
  
  # Relations
  has_many :userevents
  
  # ---- IMAGES ------
  
  has_many :images , :dependent => :destroy
  accepts_nested_attributes_for :images, :allow_destroy => true
 
  
  # ---- END IMAGES ------
  
  belongs_to :transaction
  accepts_nested_attributes_for :transaction

 
  has_many :library_elements
  has_many :libraries, :through => :library_elements


  belongs_to :seller ,:class_name => 'User', :foreign_key => 'user_id'
  validates_presence_of :user_id, :unless => :template?
  
  
  
 
  
  # see #128
  belongs_to :auction_template
  
  validates_presence_of :title , :content, :unless => :template? # refs #128 
  validates_presence_of :condition, :price_cents

  validates_numericality_of :price,
    :greater_than_or_equal_to => 0

  def title_image
    if images.empty?
      return nil
    else
      return images[0]
    end
  end
  
  # without parameter or 'true' returns all auctions with a user_id, else only 
  # the auctions with the specified user_id
  scope :with_user_id, lambda{|user_id = true|
    if user_id == true
      where(Auction.arel_table[:user_id].not_eq(nil))
    else
      where(:user_id => user_id)
    end
  } 
  
 
  
  scope :with_commendation, lambda { |*commendations|
    return scoped unless commendations.present?
    auction_table = self.arel_table
    arel_condition = nil
    commendations.each do |commendation|
      if arel_condition
        arel_condition = arel_condition.or(auction_table[commendation].eq(true))
      else
        arel_condition = auction_table[commendation].eq(true)
      end
    end
    where(arel_condition)
  }
  
  
  private

  def sanitize_content
    self.content = sanitize_tiny_mce(self.content)
  end
  
  def set_transaction_type_in_pioneer_version
    self.transaction.type  = "PreviewTransaction"
  end
  
  def set_expire_in_pioneer_version
    # unfortunaltey, DateTime.new(Float::INFINITY) raises an exception ;)
    self.expire = 5.years.from_now
  end

  def sanitize_tiny_mce(field)
    ActionController::Base.helpers.sanitize(field,
    :tags => %w(a b i strong em p param h1 h2 h3 h4 h5 h6 br hr ul li img),
    :attributes => %w(href name src type value width height data style) );
  end
  
  

  # see #128
  def template?
    # Note: 
    # * if not yet saved, there cannot be a auction_template_id
    # * the inverse reference is set in auction_template model before validation 
    auction_template_id != nil || auction_template != nil 
  end

  # For Solr searching we need category ids 
  def self.search_categories(categories)
    ids = []
    categories = self.remove_category_parents(categories)
    
    categories.each do |category|
     category.self_and_descendants.each do |fullcategories|
        ids << fullcategories.id
      end
    end
    ids
  end

end
