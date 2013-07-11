#
# Farinopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Farinopoly.
#
# Farinopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Farinopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Farinopoly.  If not, see <http://www.gnu.org/licenses/>.
#
class Library < ActiveRecord::Base

  attr_accessible :name, :public, :user, :user_id
  extend AccessibleForAdmins

  delegate :nickname, :to => :user, :prefix => true

  # Validations

  validates :name,:user, :presence => { :message => I18n.t('library.error.presence') }

  validates :name, :uniqueness => {:scope => :user_id, :message => I18n.t('library.error.uniqueness')}

  validates_length_of :name, :maximum => 25,:message => I18n.t('library.error.length')

  #Relations

  belongs_to :user

  has_many :library_elements, dependent: :destroy
  has_many :articles, through: :library_elements

  scope :public, where(public: true)

end
