#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class Content < ApplicationRecord
  extend Sanitization

  auto_sanitize :key
  auto_sanitize :body, method: 'tiny_mce', admin: true

  validates :key,  presence: true,
                   uniqueness: true

  validates :body, presence: true

  extend FriendlyId
  friendly_id :key, use: [:finders]

  default_scope { order(key: :asc) }
end
