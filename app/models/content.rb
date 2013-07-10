#
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
require 'friendly_id'

class Content < ActiveRecord::Base
  extend Sanitization

  attr_accessible :body, :key
  auto_sanitize :key
  auto_sanitize :body, method: 'tiny_mce' # Should we really sanitize :body?

  validates :key,  presence: true,
                   uniqueness: true

  validates :body, presence: true

  extend FriendlyId
  friendly_id :key
end
