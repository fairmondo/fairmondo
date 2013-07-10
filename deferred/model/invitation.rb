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
class Invitation < ActiveRecord::Base

  attr_accessible :surname , :name, :email, :relation, :trusted_1 , :trusted_2

  validate :validate_sender

  def validate_sender
    if self.sender && self.sender.trustcommunity
      return true
    else
      return false
    end
  end

  #has_one :user
  belongs_to :sender ,:class_name => 'User', :foreign_key => 'user_id'
  #belongs_to :relation ,:class_name => 'UserRelation', :foreign_key => 'user_relation'

  validates_presence_of :name, :email, :relation, :trusted_1, :trusted_2

end
