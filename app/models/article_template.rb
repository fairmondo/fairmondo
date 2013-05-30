#
# Farinopoly - Fairnopoly is an open-source online marketplace soloution.
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
class ArticleTemplate < ActiveRecord::Base

  delegate :title, :to => :article, :prefix => true

  attr_accessible :article_attributes, :name, :article,:save_as_template
  attr_accessor :save_as_template

  validates :name, :uniqueness => {:scope => :user_id}
  validates :name, :presence => true
  validates :user_id, :presence => true

  belongs_to :user
  has_one :article, :dependent => :destroy

  accepts_nested_attributes_for :article

  # refs #128 avoid default scope
  def article
    Article.unscoped{super}
  end





end
