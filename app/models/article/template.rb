module Article::Template
  extend ActiveSupport::Concern

  included do
    
    attr_accessible :article_template_attributes
    attr_accessor :article_template_attributes
    # refs #128
    default_scope where(:article_template_id => nil)

    
    before_save :build_and_save_template, :if => :save_as_template?
    accepts_nested_attributes_for :article_template, :reject_if => proc { |attributes| !attributes['save_as_template'] }
    
  
  end
  
  def save_as_template?
    self.article_template.save_as_template
  end
  
   # see #128
  def template?
    # Note:
    # * if not yet saved, there cannot be a article_template_id
    # * the inverse reference is set in article_template model before validation
    article_template_id != nil || article_template != nil
  end

    ########## build Template #################
      def build_and_save_template
        # Reown Template 
        self.article_template.article = self #ensure relation
        cloned_article_attributes = self.article_template.deep_article_attributes 
        debugger
        cloned_article = self.article_template.build_article(cloned_article_attributes)
        copy_images_to cloned_article
        self.article_template = nil
        cloned_article.save
      end
      
      def copy_images_to article
        self.images.each do |image|
            copyimage = Image.new
            copyimage.image = image.image
            article.images << copyimage
            copyimage.save
        end
      end
      
end