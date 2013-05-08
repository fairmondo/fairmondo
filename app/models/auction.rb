class Auction < ActiveRecord::Base
  extend Enumerize

  # Friendly_id for beautiful links
  extend FriendlyId
  friendly_id :title, :use => :slugged
  validates_presence_of :slug

  # refs #128
  default_scope where(:auction_template_id => nil)


  # Relations


  validates_presence_of :transaction
  belongs_to :transaction, :dependent => :destroy
  accepts_nested_attributes_for :transaction

  has_many :library_elements, :dependent => :destroy
  has_many :libraries, :through => :library_elements

  belongs_to :seller, :class_name => 'User', :foreign_key => 'user_id'
  validates_presence_of :user_id, :unless => :template?

  # see #128
  belongs_to :auction_template
  
   #auction module concerns
  include Categories, Commendation, FeesAndDonations, Images, Initial, Attributes, Search, Sanitize
  
  # without parameter or 'true' returns all auctions with a user_id, else only 
  # the auctions with the specified user_id
  scope :with_user_id, lambda{|user_id = true|
    if user_id == true
      where(Auction.arel_table[:user_id].not_eq(nil))
    else
      where(:user_id => user_id)
    end
  }




  # see #128
  def template?
    # Note:
    # * if not yet saved, there cannot be a auction_template_id
    # * the inverse reference is set in auction_template model before validation
    auction_template_id != nil || auction_template != nil
  end


  def seller_attributes=(seller_attrs)    
    self.seller = User.find(seller_attrs.delete(:id))
    rejected = seller_attrs.reject { |k,v| valid_seller_attributes.include?(k) }
    if rejected != nil && !rejected.empty? # Docs say reject! will return nil for no change but returns empty array
      raise SecurityError
    end
    self.seller.attributes = seller_attrs
  end

   # The allowed attributes for updating user/seller in auction form
  def valid_seller_attributes
    ["bank_code", "bank_account_number", "bank_account_owner" ,"paypal_account", "bank_name" ]
  end

end
