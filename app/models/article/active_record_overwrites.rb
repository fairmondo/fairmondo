module Article::ActiveRecordOverwrites
  extend ActiveSupport::Concern

  # Overwrites for Activerecord Methods

  included do

    def category_ids= category_ids
      self.categories = []
      category_ids.each do |category_id|
        if category_id.to_s.match(/\A\d+\Z/)
          self.categories << Category.find(category_id.to_i)
        end
      end
    end

    def images_attributes=(attributes)
      self.images.clear
      attributes.each do |key,image_attributes|
        if image_attributes.has_key? :id
          self.images << update_existing_image(image_attributes) unless image_attributes[:_destroy] == "1"
        else
          self.images << ArticleImage.new(image_attributes) if image_attributes[:image] != nil
        end
      end
    end

    # Alias Method Chains for ActiveRecord Methods

    def quantity_available_with_article_state
      self.active? ? quantity_available_without_article_state : 0
    end

    def quantity_available
      super || self.quantity
    end

    alias_method_chain :quantity_available, :article_state
  end

  private

    def update_existing_image image_attributes
      image = Image.find(image_attributes[:id])
      image.image = image_attributes[:image] if image_attributes.has_key? :image # updated the image itself
      image.is_title = image_attributes[:is_title]
    end



end
