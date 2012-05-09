class Userevent < ActiveRecord::Base
    belongs_to :auction, :foreign_key => ':auction_id'
end
