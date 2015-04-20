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
class Article < ActiveRecord::Base
  extend Enumerize
  extend FriendlyId
  extend Sanitization

  # Article module concerns
  include Validations, ActiveRecordOverwrites, Associations,
          Commendation, FeesAndDonations,
          Images, ExtendedAttributes, State, Scopes,
          Checks, Delegates, Commentable

  ############### Friendly_id for beautiful links
  def slug_candidates
    [
      :title,
      [:title, :seller_nickname],
      [:title, :seller_nickname, :created_at]
    ]
  end

  friendly_id :slug_candidates, use: [:slugged, :finders]

  def should_generate_new_friendly_id?
    super && slug == nil && should_get_a_slug?
  end

  ###############################################

  # ATTENTION DO NOT CALL THIS WITHOUT A TRANSACTION (See Cart#buy)
  def buy! value
    self.quantity_available -= value
    if self.quantity_available < 1
      self.remove_from_libraries
      self.buy_out!
    end
    self.save! # validation is performed on the attribute
  end

  def self.edit_as_new article
    new_article = article.amoeba_dup
    new_article.state = 'preview'
    new_article
  end

  # Elastic/Chewy - so it knows which to #import
  def delete_from_index?
    !active?
  end

  amoeba do
    enable
    include_association :fair_trust_questionnaire
    include_association :social_producer_questionnaire
    customize lambda { |original_article, new_article|
      new_article.categories = original_article.categories
      # move images to new article
      original_article.images.each do |image|
        image = new_article.images.build(
          image: image.image,
          is_title: image.is_title,
          external_url: image.external_url) rescue nil
        image.save
      end
      new_article.quantity_available = nil
      # unset slug on templates
      if original_article.is_template? || original_article.save_as_template? # cloned because of template handling
        new_article.slug = nil
      else # cloned because of edit_as_new
        new_article.original_id = original_article.id # will be used in after_create; see observer
      end
    }
  end
end
