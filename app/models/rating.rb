#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class Rating < ActiveRecord::Base
  extend Enumerize

  belongs_to :line_item_group

  belongs_to :rated_user, class_name: 'User', inverse_of: :ratings
  has_one :rating_user, through: :line_item_group, source: :buyer, inverse_of: :given_ratings
  enumerize :rating, in: [:positive, :neutral, :negative]
  delegate :update_rating_counter, to: :rated_user

  validates :rating, :rated_user_id, :line_item_group_id, presence: true
  validates :text, length: { maximum: 2500 }
  # auto_sanitize :text
  validates :line_item_group_id, uniqueness: true, presence: true

  after_save :update_rating_counter

  default_scope { order('created_at DESC') }

  alias_method :value, :rating # to avoid structure 'rating_rating' in shared/show_article_listitem
end
