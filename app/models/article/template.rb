module Article::Template
  extend ActiveSupport::Concern

  included do
    
  end

    ########## build Template #################
      def build_and_save_template(article)
        if template_attributes = params[:article_template]
          if template_attributes[:save_as_template] && template_attributes[:name].present?
            template_attributes[:article_attributes] = params[:article]
            @article_template = ArticleTemplate.new(template_attributes)
            @article_template.article.seller = article.seller
            @article_template.article.images.clear
            article.images.each do |image|
              copyimage = Image.new
              copyimage.image = image.image
              @article_template.article.images << copyimage
              copyimage.save
            end
    
          @article_template.user = article.seller
          @article_template.save
          else
          true
          end
        else
        true
        end
      end
      
end