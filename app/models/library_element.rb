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
class LibraryElement < ActiveRecord::Base

  attr_accessible :article, :library, :library_id, :article_id

  delegate :name, :user_id , :to => :library , :prefix => true
  delegate :title, :to => :article, :prefix => true

  # Validations
  validates :library_id, :uniqueness => {:scope => :article_id , :message => I18n.t('library_element.error.uniqueness') }
  validates :library_id , :presence => true

  # Relations
  belongs_to :article
  belongs_to :library, counter_cache: true

end
