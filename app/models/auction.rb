class Auction < ActiveRecord::Base
  extend Enumerize

  before_validation :sanitize_content, :on => :create

  validate :transaction_type
  
  validates_presence_of :expire
  validate :validate_expire
  
  after_initialize do
    self.quantity = 1
    self.price = 1
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

  #TODO transaction_type makes factory create invalid auctions. Why?
  def transaction_type
    case transaction
    when 'auction'
      self.transaction = AuctionTransaction.new
      self.transaction.auction = self
    when 'preview'
      self.transaction = PreviewTransaction.new
      self.transaction.auction = self
    else
    errors.add(:transaction, "You must select a type for your transaction!")
    end
  end

  attr_accessor :transaction, :category_proposal
  acts_as_indexed :fields => [:title, :content]
  acts_as_followable

  enumerize :condition, :in => [:new ,:fair , :old ]
  enumerize :color, :in => [:white, :black, :yellow, :orange, :red, :green, :blue, :turquoise, :brown, :violet, :grey, :multicolored]   
  validates_length_of :size, :maximum => 4
  validates_numericality_of :quantity, :greater_than_or_equal_to => 1
    
  # Note: currency is deprecated for the moment.
  enumerize :price_currency, :in => [:EUR]

  monetize :price_cents
  
  serialize :transport, Array
  enumerize :transport, :in => [:pickup, :insured, :uninsured], :multiple => true 
  validates_presence_of :transport
  
  serialize :payment, Array
  enumerize :payment, :in => [:bank_transfer, :cash, :paypal, :cach_on_delivery, :invoice], :multiple => true
  validates_presence_of :payment
  
  #Relations
  has_many :userevents
  has_many :images

  belongs_to :seller ,:class_name => 'User', :foreign_key => 'user_id'
  belongs_to :category
  belongs_to :alt_category_1 , :class_name => 'Category' , :foreign_key => :alt_category_id_1
  belongs_to :alt_category_2 , :class_name => 'Category' , :foreign_key => :alt_category_id_2

  validates_presence_of :title , :content, :category, :condition, :price_cents
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
  
  # returns all auctions without category
  scope :with_category, lambda {|category = nil|
    return Auction.scoped unless category.present?
    auctions = users = Arel::Table.new(:auctions)
    where(
      auctions[:category_id].eq(category).or(
      auctions[:alt_category_id_1].eq(category)).or(
      auctions[:alt_category_id_2].eq(category))
    )
  }
  

  private

  def sanitize_content
    self.content = sanitize_tiny_mce(self.content)
  end

  def sanitize_tiny_mce(field)
    ActionController::Base.helpers.sanitize(field,
    :tags => %w(a b i strong em p param h1 h2 h3 h4 h5 h6 br hr ul li img),
    :attributes => %w(href name src type value width height data) );
  end

end
