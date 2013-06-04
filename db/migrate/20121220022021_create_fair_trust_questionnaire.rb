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
class CreateFairTrustQuestionnaire < ActiveRecord::Migration
  def up
    create_table :fair_trust_questionnaires do |t|
      t.integer :auction_id

      t.boolean :support
      t.text :support_explanation

      t.boolean :transparency
      t.text :transparency_explanation

      t.boolean :collaboration
      t.text :collaboration_explanation

      t.boolean :minimum_wage
      t.text :minimum_wage_explanation

      t.boolean :child_labor
      t.text :child_labor_explanation

      t.boolean :sexual_equality
      t.text :sexual_equality_explanation

      t.boolean :labor_conditions
      t.text :labor_conditions_explanation

      t.boolean :producer_advancement
      t.text :producer_advancement_explanation

      t.boolean :awareness_raising
      t.text :awareness_raising_explanation

      t.boolean :environment_protection
      t.text :environment_protection_explanation
    end
  end

  def down
    drop_table :fair_trust_questionnaires
  end
end
