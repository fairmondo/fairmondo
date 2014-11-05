# This module compiles all checks (usually ending with aquestion mark) called
# on an article.
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
module Article::Associations
  extend ActiveSupport::Concern

  included do

    has_and_belongs_to_many :categories

    has_many :business_transactions, inverse_of: :article
    has_many :line_items, inverse_of: :article

    has_many :library_elements, dependent: :destroy
    has_many :libraries, through: :library_elements

    belongs_to :seller, class_name: 'User', foreign_key: 'user_id'
    alias_method :user, :seller
    alias_method :user=, :seller=

    belongs_to :original, class_name: 'Article', foreign_key: 'original_id'
    # the article that this article is a copy of, if applicable

    has_many :mass_upload_articles
    has_many :mass_uploads, through: :mass_upload_articles

    belongs_to :friendly_percent_organisation,
      class_name: 'User', foreign_key: 'friendly_percent_organisation_id'
    belongs_to :discount

    # images

    has_many :images, class_name: "ArticleImage", foreign_key: "imageable_id"
    has_many :thumbnails, -> { reorder('is_title DESC,id ASC').offset(1) },
      class_name: "ArticleImage", foreign_key: "imageable_id"
    has_one :title_image, -> { reorder 'is_title DESC,id ASC' },
      class_name: "ArticleImage", foreign_key: "imageable_id"

    accepts_nested_attributes_for :images, allow_destroy: true

  end
end
