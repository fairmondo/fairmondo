class Auction < ActiveRecord::Base
   has_many :userevents
   belongs_to :seller ,:class_name => 'User', :foreign_key => 'user_id'
   belongs_to :category
   belongs_to :alt_category_1 , :class_name => 'Category' , :foreign_key => :alt_category_id_1
    belongs_to :alt_category_2 , :class_name => 'Category' , :foreign_key => :alt_category_id_2
   belongs_to :category
   validates_presence_of :title , :content, :seller
end
