class Auction < ActiveRecord::Base
   include Enumerize
   enumerize :condition, :in => [:new ,:fair , :old ]
  #Relations
   has_many :userevents
   has_many :bids
   has_many :images
   has_one :max_bid ,:class_name => 'Bid'
   belongs_to :seller ,:class_name => 'User', :foreign_key => 'user_id'
   belongs_to :category
   belongs_to :alt_category_1 , :class_name => 'Category' , :foreign_key => :alt_category_id_1
   belongs_to :alt_category_2 , :class_name => 'Category' , :foreign_key => :alt_category_id_2
   belongs_to :category
   
   validates_presence_of :title , :content, :category, :condition
   
   def title_image 
     if images.empty?
       return nil
     else
       return images[0]
     end
   end
end
