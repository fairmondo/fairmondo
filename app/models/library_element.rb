#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class LibraryElement < ActiveRecord::Base
  delegate :name, :user_id, to: :library, prefix: true
  delegate :title, to: :article_reduced, prefix: true

  # Validations
  validates :library_id, uniqueness: { scope: :article_id }
  validates :library_id, presence: true

  # Relations
  belongs_to :article
  belongs_to :article_reduced, ->(_o) { reduced }, class_name: 'Article', foreign_key: 'article_id'
  belongs_to :library, counter_cache: true
  has_one :user, through: :library

  scope :active, -> { where.not(inactive: true) }
  # Scopes
  default_scope { order(created_at: :desc) }
end
