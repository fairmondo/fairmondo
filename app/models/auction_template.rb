class AuctionTemplate < ActiveRecord::Base
  attr_accessible :auction_attributes, :save_as_template, :name, :auction
  
  validates :name, :uniqueness => {:scope => :user_id}
  validates :name, :presence => true
  validates :user_id, :presence => true
  
  attr_accessor :save_as_template
  
  belongs_to :user
  has_one :auction, :dependent => :destroy
  
  validate :auctions_auction_template

  accepts_nested_attributes_for :auction
  
  # refs #128 avoid default scope
  def auction
    Auction.unscoped{super}
  end
    
  def deep_auction_attributes
    auction_attributes = auction.attributes
    nested_keys = auction.nested_attributes_options.keys
    nested_keys.each do |key|
      relation = auction.send(key)
      if relation.present?
        
        if relation.is_a?(Array) || relation.is_a?(ActiveRecord::Relation)
          if key == :images
            #ommit since we have to copy the images for new
          else
          # Commented. Currenty, auction does not have has_many relations that accept nested attributes besides images! Images are c 
          #  auction_attributes["#{key}_attributes"] = []
          #  relation.each do |record|
          #    auction_attributes["#{key}_attributes"] << record.attributes.except(*non_assignable_values)
          #  end
          
            # omit since we 
          end
        else
      
          auction_attributes["#{key}_attributes"] = relation.attributes.except(*non_assignable_values)
        end
      end
    end
    auction_attributes["category_ids"] = auction.category_ids
    auction_attributes
  end
  
  private
  
  def non_assignable_values
    ["id","created_at","updated_at","auction_id"]
  end
  
  def auctions_auction_template
    # see https://github.com/rails/rails/issues/586: 
    # work in progress - :before_add does not yet exist for has_one
    if auction
      auction.auction_template ||= self
    else
      errors[:auction] << I18n.t('active_record.error_messages.empty')
    end
  end
  
end
