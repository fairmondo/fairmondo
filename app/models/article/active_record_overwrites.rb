#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

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
      attributes.each do |_key, image_attributes|
        if image_attributes.key?(:id)
          unless image_attributes[:_destroy] == '1'
            self.images << update_existing_image(image_attributes)
          end
        else
          if image_attributes[:image] != nil
            self.images << ArticleImage.new(image_attributes)
          end
        end
      end
    end

    # Alias Method Chains for ActiveRecord Methods

    def quantity_available_with_article_state
      self.active? ? quantity_available_without_article_state : 0
    end

    def quantity_available
      super || quantity
    end

    alias_method_chain :quantity_available, :article_state
  end

  private

  def update_existing_image image_attributes
    image = Image.find(image_attributes[:id])
    if image_attributes.key? :image # updated the image itself
      image.image = image_attributes[:image]
    end
    image.is_title = image_attributes[:is_title]
    image
  end
end
