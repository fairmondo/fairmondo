#
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
module Article::Images
  extend ActiveSupport::Concern

  included do
    # ---- IMAGES ------
    IMAGE_COUNT = 1

    def self.image_attrs
      attrs = [ images_attributes: Image.image_attrs(true) ]
      IMAGE_COUNT.times do |number|
        attrs.push "image_#{number+2}_url".to_sym
      end
      attrs
    end

    has_many :images, :class_name => "ArticleImage", foreign_key: "imageable_id"

    delegate :external_url, to: :title_image, :prefix => true

    accepts_nested_attributes_for :images, allow_destroy: true

    validate :only_one_title_image

    validates :images, :size => {
      :in => 0..5 # lower to 3 if the old 5 article pics are all gone
    }

    # Gives first image if there is one
    # @api public
    # @return [Image, nil]
    def title_image
      images.title_image || images[0]
    end

    def title_image_url style = nil
      if title_image
        if title_image.image.processing? && style != :thumb
          title_image.original_image_url_while_processing
        else
          title_image.image.url(style)
        end
      else
        "missing.png"
      end
    end

    def title_image_url_thumb
      title_image_url :thumb
    end

    def title_image_present?
      title_image && title_image.image.present?
    end


    IMAGE_COUNT.times do |number|
      define_method("image_#{number+2}_url=".to_sym, Proc.new{ |image_url|
                          add_image(image_url, false)})
    end

    def thumbnails
      thumbnails = self.images.where(:is_title => false).to_a
      thumbnails.reject! {|image| image.id == title_image.id if title_image}
      thumbnails
    end


    def only_one_title_image
      count_images = 0
      title_images = self.images.each do |image|
        count_images+=1 if image.is_title
      end
      if count_images > 1
         errors.add(:images, I18n.t("article.form.errors.only_one_title_image"))
      end
    end

    def external_title_image_url=(image_url)
      add_image(image_url, true)
    end

    def add_image(image_url, should_be_title)
      return unless image_url

      self.images.each do |image|
        if image.is_title == should_be_title
          if image.external_url == image_url
            return
          else
            image.delete
          end
        end
      end

      # TODO needs refactoring to be more dynamic
      if image_url && image_url =~ URI::regexp
        begin
          image = Timeout::timeout(60) do # 1 minute timeout (should even cover very large images)
            ArticleImage.new(image: URI.parse(image_url))
          end
          image.is_title = should_be_title
          image.external_url = image_url
          #image.save
          self.images << image
        rescue
          self.errors.add((should_be_title ? :external_title_image_url : :image_2_url), I18n.t('mass_uploads.errors.image_not_available'))
        end
      elsif image_url !=~ URI::regexp && should_be_title == true
        self.errors.add(:external_title_image_url, I18n.t('mass_uploads.errors.wrong_external_title_image_url'))
      elsif image_url !=~ URI::regexp && should_be_title == false
        self.errors.add(:image_2_url, I18n.t('mass_uploads.errors.wrong_image_2_url'))
      end
    end

    def cleanup_images
      self.images.each{ |i| i.destroy } unless self.keep_images
    end

  end
end
