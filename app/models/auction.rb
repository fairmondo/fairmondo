class Auction < ActiveRecord::Base
  extend Enumerize
  
  AUCTION_FEES = {
    :min => 0.1,
    :max => 30.0,
    :fair => 0.03,
    :default => 0.06
  }
  
  # refs #128
  default_scope where(:auction_template_id => nil)

  before_validation :sanitize_content, :on => :create

  validate :transaction_type
  
  validates_presence_of :expire
  validate :validate_expire
  
  after_initialize :initialize_values
  
  def initialize_values
    begin
    self.quantity ||= 1
    self.price ||= 1
    self.friendly_percent ||= 0
    
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
    
  def friendly_percent_calculated
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
    price * corruption_percentage
  end
  
  alias_method :friendly_percent_result, :friendly_percent_calculated
  
  def fee_percentage
    if fair? || ecologic?
      AUCTION_FEES[:fair]
    else
      AUCTION_FEES[:default]
    end
  end
  
  def fees
    unless @fees
      r = price * fee_percentage
      min = Money.new(AUCTION_FEES[:min]*100)
      r = min if r < min
      max = Money.new(AUCTION_FEES[:max]*100)
      r = max if r > max
      @fees = r
    end
    @fees
  end
  
  def fees_and_donations
    friendly_percent_result + corruption_percent_result + fees
  end
    
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

  def transaction_type
    return if transaction.is_a?(Transaction) # already initialized
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

  enumerize :condition, :in => [:new, :old]
  enumerize :color, :in => [:white, :black, :yellow, :orange, :red, :green, :blue, :turquoise, :brown, :violet, :grey, :multicolored]   
  validates_length_of :size, :maximum => 4
  validates_numericality_of :quantity, :greater_than_or_equal_to => 1
    
  # Note: currency is deprecated for the moment.
  enumerize :price_currency, :in => [:EUR]

  monetize :price_cents
  
  serialize :transport, Array
  enumerize :transport, :in => [:pickup, :insured, :uninsured], :multiple => true 
  validates :transport, :size => 1..-1
  
  serialize :payment, Array
  enumerize :payment, :in => [:bank_transfer, :cash, :paypal, :cach_on_delivery, :invoice], :multiple => true
  validates :payment, :size => 1..-1
  
  # Relations
  has_many :userevents
  has_many :images

  belongs_to :seller ,:class_name => 'User', :foreign_key => 'user_id'
  validates_presence_of :user_id, :unless => :template?
  
  # categories refs #154 
  has_many :auctions_categories, :dependent => :destroy
  has_many :categories, :through => :auctions_categories
  validates :categories, :size => {
    :in => 1..2, :messages => {
      :minimum_entries => I18n.t('errors.messages.minimum_categories'),
      :maximum_entries => I18n.t('errors.messages.maximum_categories')
    },
    :add_errors_to => [:categories, :categories_with_parents]
  }
  before_validation :ensure_no_redundant_categories # just store the leafs to avoid inconsistencies
    
  def categories_with_parents
    (categories + categories.map(&:ancestors)).flatten.uniq    
  end
  
  def categories_with_parents=(csorig)
    cs = csorig
    if cs.first.is_a?(String) || cs.first.is_a?(Integer) 
      cs = cs.select(&:present?).map(&:to_i)
      cs = Category.where("'categories'.'id' IN (?)",cs)
    else
      cs = cs.dup
    end
    # remove entries which parent is not included in the subtree
    # e.g. you selected Hardware but unselected Computer afterwards
    cs = cs.reject{|c| (c.parent && ! cs.include?(c.parent)) }
    # remove all parents
    self.categories = self.class.remove_category_parents(cs)  
  end
  # end categories
  
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
  
  # returns all auctions without category
  scope :with_category, lambda {|category_id = nil|
    return Auction.scoped unless category_id.present?
    
    joins(:auctions_categories).where("'auctions_categories'.'category_id' = ?", category_id)
  }
  
  # for convenience, this method does exclude all ancesors from the passed collection
  # because searching for Hardware you don't want to get all results from Computer
  scope :with_categories, lambda {|category_ids = []|
    category_ids = category_ids.select(&:present?).map(&:to_i)
    return Auction.scoped unless category_ids.present?
    categories = Category.where("id IN (?)",category_ids)
    categories = self.remove_category_parents(categories)
    joins(:auctions_categories).where("'auctions_categories'.'category_id' IN (?)", categories.map(&:id))
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
  
  def ensure_no_redundant_categories
    self.categories = self.class.remove_category_parents(self.categories) if self.categories
    true
  end
  
  def self.remove_category_parents(categories)
    categories.reject{|c| categories.any? {|other| other.is_descendant_of?(c) } }
  end

  # see #128
  def template?
    # Note: 
    # * if not yet saved, there cannot be a auction_template_id
    # * the inverse reference is set in auction_template model before validation 
    auction_template_id != nil || auction_template != nil 
  end

end
