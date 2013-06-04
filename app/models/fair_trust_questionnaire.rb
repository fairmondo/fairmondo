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
class FairTrustQuestionnaire < ActiveRecord::Base

  attr_accessible :support, :support_explanation,
   :transparency, :transparency_explanation,
   :collaboration,:collaboration_explanation,
   :minimum_wage, :minimum_wage_explanation,
   :child_labor, :child_labor_explanation,
   :sexual_equality, :sexual_equality_explanation ,
   :labor_conditions, :labor_conditions_explanation,
   :producer_advancement,:producer_advancement_explanation,
   :awareness_raising, :awareness_raising_explanation,
   :environment_protection,:environment_protection_explanation

  belongs_to :article

  validates_presence_of :support
  validates_presence_of :support_explanation
  validates_presence_of :transparency
  validates_presence_of :transparency_explanation

  validates_presence_of :minimum_wage
  validates_presence_of :minimum_wage_explanation
  validates_presence_of :child_labor_explanation, :if => :child_labor?

  validates_presence_of :sexual_equality
  validates_presence_of :sexual_equality_explanation

  # :collaboration_explanation
  # :labor_conditions_explanation
  # :producer_advancement_explanation
  # :awareness_raising_explanation
  # :environment_protection_explanation

end
