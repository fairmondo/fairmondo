class Auction < ActiveRecord::Base
  
  before_validation :sanitize_content, :on => :create

  
  acts_as_indexed :fields => [:title, :content]
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
   belongs_to :category
   
   validates_presence_of :title , :content, :category, :condition, :price_cents , :price_currency
   
   def title_image 
     if images.empty?
       return nil
     else
       return images[0]
     end
   end
   
  
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
