# This module compiles all checks (usually ending with aquestion mark) called on an article.
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
module User::Associations
  extend ActiveSupport::Concern

  included do
    # Addresses
    has_many :addresses, dependent: :destroy, inverse_of: :user
    belongs_to :standard_address, class_name: 'Address', foreign_key: :standard_address_id
    delegate :title, :first_name, :last_name, :company_name, :address_line_1, :address_line_2, :zip, :city, :country, to: :standard_address, prefix: true, allow_nil: true

    # Profile image
    has_one :image, class_name: 'UserImage', foreign_key: 'imageable_id'
    accepts_nested_attributes_for :image, reject_if: :all_blank

    # Articles and Mass uploads
    has_many :articles, dependent: :destroy # As seller
    # has_many :bought_business_transactions, through: :buyer_line_item_groups#, source: :line_item_groups
    # has_many :bought_articles, through: :bought_business_transactions, source: :article
    has_many :mass_uploads

    # Cart related Models
    has_many :carts # as buyer
    # has_many :line_item_groups, foreign_key: 'seller_id', inverse_of: :seller # as seller
    # has_many :line_item_groups, foreign_key: 'buyer_id', inverse_of: :buyer  # as buyer
    has_many :seller_line_item_groups, class_name: 'LineItemGroup', foreign_key: 'seller_id', inverse_of: :seller
    has_many :buyer_line_item_groups, class_name: 'LineItemGroup', foreign_key: 'buyer_id', inverse_of: :buyer

    # Libraries and Library Elements
    has_many :libraries, dependent: :destroy
    has_many :library_elements, through: :libraries

    # Ratings
    has_many :ratings, foreign_key: 'rated_user_id', dependent: :destroy, inverse_of: :rated_user
    has_many :given_ratings, through: :buyer_line_item_groups, source: :rating, inverse_of: :rating_user

    has_many :library_elements, through: :libraries

    has_many :hearts
    has_many :comments, dependent: :destroy

    has_many :hearted_libraries, through: :hearts, source: :heartable, source_type: 'Library'

    has_attached_file :cancellation_form
  end
end
