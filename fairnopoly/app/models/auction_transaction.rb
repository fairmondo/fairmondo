class AuctionTransaction < Transaction
   has_one :max_bid ,:class_name => 'Bid'
   has_many :bids
end