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

    has_many :images, as: :imageable #has_and_belongs_to_many :images


    accepts_nested_attributes_for :images, allow_destroy: true

    validate :only_one_title_image

    # Gives first image if there is one
    # @api public
    # @return [Image, nil]
    def title_image
      images.each do |image|
        return image if image.is_title
      end
      if images.empty?
        return nil
      else
        return images[0]
      end
    end

    def title_image_url type = nil
      if title_image
        title_image.image.url(type)
      else
        "missing.png"
      end
    end

    def title_image_present?
      title_image && title_image.image.present?
    end

    IMAGE_COUNT.times do |number|
      define_method("image_#{number+2}_url=".to_sym, Proc.new{ |image_url|
                          add_image(image_url, false)})
    end

    def thumbnails
      thumbnails = self.images.where(:is_title => false)
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

    def add_image(image_url, is_title)
      # bugbug refactor asap
      if image_url && image_url =~ URI::regexp
        image = Image.new
        image.is_title = is_title
        image.external_url = image_url
        image.save
        self.images << image
      elsif image_url !=~ URI::regexp && is_title == true
        self.errors.add(:base, I18n.t('mass_upload.errors.wrong_external_title_image_url'))
      elsif image_url !=~ URI::regexp && is_title == false
        self.errors.add(:base, I18n.t('mass_upload.errors.wrong_image_2_url'))
      end
    end

    def extract_external_image!
      self.images.each do |image|
        begin
        image.update_attributes(:image => URI.parse(image.external_url))
        rescue
        end
      end
    end
    handle_asynchronously :extract_external_image!
  end
end
