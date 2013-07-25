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
  extend Enumerize

  # Question 1: supports marginalized workers (req)
  attr_accessible :support, :support_checkboxes, :support_explanation,
    # Question 2: labor conditions acceptable? (req)
    :labor_conditions, :labor_conditions_checkboxes, :labor_conditions_explanation,
    # Question 3: is production environmentally friendly (opt)
    :environment_protection, :environment_protection_checkboxes, :environment_protection_explanation,
    # Question 4: does controlling of these standards exist (req)
    :controlling, :controlling_checkboxes, :controlling_explanation,
    # Question 5: awareness raising programs supported? (opt)
    :awareness_raising, :awareness_raising_checkboxes, :awareness_raising_explanation

  belongs_to :article

  # Q1

  serialize :support_checkboxes, Array
  enumerize :support_checkboxes, in: [
    :prefinance,
    :longterm,
    :development,
    :minimum_wage,
    :higher_prices,
    :direct_negotiations,
    :community,
    :premiums,
    :other
  ]

  validates :support, presence: true
  validates :support_checkboxes, presence: true, if: :support
  validates :support_explanation, presence: true, if: :support

  # Q2

  serialize :labor_conditions_checkboxes, Array
  enumerize :labor_conditions_checkboxes, in: [
    :secure_environment,
    :hygiene,
    :working_hours,
    :free_assembly,
    :advocacy_group,
    :sexual_equality,
    :no_discrimination,
    :child_labor_ban,
    :child_labor_restrictions,
    :other
  ]

  validates :labor_conditions, presence: true
  validates :labor_conditions_checkboxes, presence: true, if: :labor_conditions
  validates :labor_conditions_explanation, presence: true, if: :labor_conditions

  # Q3

  serialize :environment_protection_checkboxes, Array
  enumerize :environment_protection_checkboxes, in: [
    :chemical_fertilizers,
    :pesticides,
    :waste_management,
    :recycling,
    :renewable_energies,
    :ecological_farming,
    :ecological_farming_transition,
    :other
  ]

  #validates :environment_protection, presence: true
  validates :environment_protection_checkboxes, presence: true, if: :environment_protection
  #validates :environment_protection_explanation, presence: true, if: :environment_protection

  # Q4

  serialize :controlling_checkboxes, Array
  enumerize :controlling_checkboxes, in: [
    :transparent_supply_chain,
    :annual_reports,
    :inspectors,
    :producer_visits,
    :own_system,
    :other
  ]

  # remove? I18n.t('article.form.errors.FairTrustQuestionnaire.invalid')
  validates :controlling, presence: true
  validates :controlling_checkboxes, presence: true, if: :controlling
  validates :controlling_explanation, presence: true, if: :controlling

  # Q5

  serialize :awareness_raising_checkboxes, Array
  enumerize :awareness_raising_checkboxes, in: [
    :producer_transparency,
    :employee_transparency,
    :price_transparency,
    :responsible_consumption_education,
    :global_market_education,
    :fair_trade_concept,
    :other
  ]

  #validates :awareness_raising, presence: true
  validates :awareness_raising_checkboxes, presence: true, if: :awareness_raising
  #validates :awareness_raising_explanation, presence: true, if: :awareness_raising

end
