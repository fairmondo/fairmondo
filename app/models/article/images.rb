#
#
# == License:
# Fairmondo - Fairmondo is an open-source online marketplace.
# Copyright (C) 2013 Fairmondo eG
#
# This file is part of Fairmondo.
#
# Fairmondo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairmondo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairmondo.  If not, see <http://www.gnu.org/licenses/>.
#
module Article::Images
  extend ActiveSupport::Concern

  included do
    delegate :external_url, to: :title_image, :prefix => true
    attr_accessor :external_title_image_url, :image_2_url # MassUpload

    def title_image_url style = nil
      if title_image_present?
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
      title_image && title_image.image.present? #&& image_accessible?
    end

    validates :external_title_image_url, :image_2_url, :format => URI::regexp(%w(http https)), allow_blank: true
    #I18n.t('mass_uploads.errors.wrong_external_title_image_url')
    #I18n.t('mass_uploads.errors.wrong_image_2_url')

    after_validation :store_external_images
    after_save :cleanup_old_images

    def store_external_images
      return if self.errors.any?
      replace_image true, :external_title_image_url if external_title_image_url.present?
      replace_image false, :image_2_url if image_2_url.present?
    end

    def replace_image should_be_title, attribute
      old_image = self.images.select{|i| i.is_title == should_be_title}.first
      return if old_image && old_image.external_url == self.send(attribute)
      self.images.delete old_image if old_image # delete this image from the instance to not cause unique validation errors
      image = load_new_image attribute, should_be_title
      @old_image = old_image if old_image && image
    end

    def cleanup_old_images
      @old_image.destroy if @old_image # destroy old image if everything is fine
    end

    def load_new_image attribute, should_be_title
      begin
        image = Timeout::timeout(60) do # 1 minute timeout (should even cover very large images)
          self.images.build(image: URI.parse(self.send(attribute)), is_title: should_be_title, external_url: self.send(attribute))
        end
      rescue
         self.errors.add(attribute, I18n.t('mass_uploads.errors.image_not_available'))
         image = nil
      end
      image
    end

    def cleanup_images
      self.images.each do |i|
        i.write_path_to_file_for('deletions')
        i.destroy
      end
    end
  end
end
