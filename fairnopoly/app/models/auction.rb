class Auction < ActiveRecord::Base
   has_many :userevents
   validates_presence_of :title , :content
end
