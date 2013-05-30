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
module Article::Initial
  extend ActiveSupport::Concern

  included do
   after_initialize :initialize_values
   after_initialize :build_dependencies
  end

  def initialize_values
    begin
    self.quantity ||= 1
    self.price ||= 1
    self.friendly_percent ||= 0
    self.active = false if self.new_record?
    # Auto-Completion raises MissingAttributeError:
    # http://www.tatvartha.com/2011/03/activerecordmissingattributeerror-missing-attribute-a-bug-or-a-features/
    rescue ActiveModel::MissingAttributeError
    end
  end

  def build_dependencies
    self.build_transaction unless self.transaction
    self.build_fair_trust_questionnaire unless self.fair_trust_questionnaire
    self.build_social_producer_questionnaire unless self.social_producer_questionnaire
  end


end
