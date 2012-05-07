class Auction < ActiveRecord::Base
   has_many :userevents
   belongs_to :seller ,:class_name => 'User', :foreign_key => 'user_id'
   validates_presence_of :title , :content, :seller
end
