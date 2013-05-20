module Article::Images
  extend ActiveSupport::Concern

  included do
    # ---- IMAGES ------
    attr_accessible :images_attributes

    has_and_belongs_to_many :images
    accepts_nested_attributes_for :images, :allow_destroy => true

    def title_image
      if images.empty?
        return nil
      else
        return images[0]
      end
    end

  end
end