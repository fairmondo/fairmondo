#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'ffaker'

FactoryGirl.define do
  factory :fair_trust_questionnaire do
    support true
    support_checkboxes [:prefinance, :longterm, :development, :minimum_wage, :higher_prices, :direct_negotiations, :community, :premiums, :other]
    support_explanation { Faker::Lorem.sentence(200) }
    support_other 'Sonstiges'

    labor_conditions true
    labor_conditions_checkboxes [
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
    labor_conditions_explanation { Faker::Lorem.sentence(200) }
    labor_conditions_other 'Sonstiges'

    environment_protection true
    environment_protection_checkboxes [
      :chemical_fertilizers,
      :pesticides,
      :waste_management,
      :recycling,
      :renewable_energies,
      :ecological_farming,
      :ecological_farming_transition,
      :other
    ]
    environment_protection_explanation { Faker::Lorem.sentence(200) }
    environment_protection_other 'Sonstiges'

    controlling true
    controlling_checkboxes [
      :transparent_supply_chain,
      :annual_reports,
      :inspectors,
      :producer_visits,
      :own_system,
      :other
    ]
    controlling_explanation { Faker::Lorem.sentence(200) }
    controlling_other 'Sonstiges'

    awareness_raising true
    awareness_raising_checkboxes [
      :producer_transparency,
      :employee_transparency,
      :price_transparency,
      :responsible_consumption_education,
      :global_market_education,
      :fair_trade_concept,
      :other
    ]
    awareness_raising_explanation { Faker::Lorem.sentence(200) }
    awareness_raising_other 'Sonstiges'
  end
end
