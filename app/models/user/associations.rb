#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

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
