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
class Library < ActiveRecord::Base
  extend Sanitization, Enumerize

  def self.library_attrs
    [:name, :public, :user, :user_id]
  end
  auto_sanitize :name
  #! attr_accessible *library_attributes
  #! attr_accessible *library_attributes, :as => :admin

  delegate :nickname, to: :user, prefix: true

  validates :name, :user, presence: true
  validates :name, uniqueness: {scope: :user_id}, length: {maximum: 70}

  enumerize :exhibition_name, in: [:donation_articles, :old, :queue1, :queue2,
    :queue3, :queue4, :book1, :book2, :book3, :book4, :book5, :book6, :book7,
    :book8]

  #Relations

  belongs_to :user

  has_many :library_elements, dependent: :destroy
  has_many :articles, through: :library_elements

  scope :public, where(public: true)
  default_scope order('updated_at DESC')

end
