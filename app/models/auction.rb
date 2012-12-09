class Auction < ActiveRecord::Base

  before_validation :sanitize_content, :on => :create

  validate :transaction_type

  validate :validate_expire
  
  def validate_expire
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

  attr_accessor :transaction
  acts_as_indexed :fields => [:title, :content]
  acts_as_followable

  include Enumerize
  enumerize :condition, :in => [:new ,:fair , :old ]
  enumerize :price_currency, :in => [:EUR]

  monetize :price_cents
  #Relations
  has_many :userevents
  has_many :images

  belongs_to :seller ,:class_name => 'User', :foreign_key => 'user_id'
  belongs_to :category
  belongs_to :alt_category_1 , :class_name => 'Category' , :foreign_key => :alt_category_id_1
  belongs_to :alt_category_2 , :class_name => 'Category' , :foreign_key => :alt_category_id_2

  validates_presence_of :title , :content, :category, :condition, :price_cents , :price_currency, :expire, :payment
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
