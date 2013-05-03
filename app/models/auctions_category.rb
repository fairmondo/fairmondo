class AuctionsCategory < ActiveRecord::Base
  attr_accessible :auction_id, :category_id

  belongs_to :auction
  belongs_to :category

end
