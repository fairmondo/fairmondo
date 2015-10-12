#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class FairTrustQuestionnaire < ActiveRecord::Base
  extend Enumerize
  extend Sanitization
  include QuestionnaireInitializer

  auto_sanitize :support_explanation, :support_other,
                :labor_conditions_explanation, :labor_conditions_other,
                :environment_protection_explanation, :environment_protection_other,
                :controlling_explanation, :controlling_other,
                :awareness_raising_explanation, :awareness_raising_other

  belongs_to :article

  # Question 1: supports marginalized workers (req)

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
  ], multiple: true

  validates :support, presence: true
  validates :support_checkboxes, presence: true,
                                 size: { in: 3..-1 },
                                 if: :support
  validates :support_explanation, presence: true,
                                  length: { minimum: 150, maximum: 10000 },
                                  if: :support
  validates :support_other, fair_trust_other: true

  # Question 2: labor conditions acceptable? (req)

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
  ], multiple: true

  validates :labor_conditions, presence: true
  validates :labor_conditions_checkboxes, presence: true,
                                          size: { in: 4..-1 },
                                          if: :labor_conditions
  validates :labor_conditions_explanation, presence: true,
                                           length: { minimum: 150, maximum: 10000 },
                                           if: :labor_conditions
  validates :labor_conditions_other, fair_trust_other: true

  # Question 3: is production environmentally friendly (opt)

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
  ], multiple: true

  # validates :environment_protection, presence: true
  validates :environment_protection_checkboxes, presence: true,
                                                if: :environment_protection
  validates :environment_protection_explanation, length: { minimum: 150, maximum: 10000 },
                                                 if: :environment_protection
  validates :environment_protection_other, fair_trust_other: true

  # Question 4: does controlling of these standards exist (req)

  serialize :controlling_checkboxes, Array
  enumerize :controlling_checkboxes, in: [
    :transparent_supply_chain,
    :annual_reports,
    :inspectors,
    :producer_visits,
    :own_system,
    :other
  ], multiple: true

  # remove? I18n.t('article.form.errors.FairTrustQuestionnaire.invalid')
  validates :controlling, presence: true
  validates :controlling_checkboxes, presence: true,
                                     size: { in: 2..-1 }, if: :controlling
  validates :controlling_explanation, presence: true,
                                      length: { minimum: 150, maximum: 10000 },
                                      if: :controlling
  validates :controlling_other, fair_trust_other: true

  # Question 5: awareness raising programs supported? (opt)

  serialize :awareness_raising_checkboxes, Array
  enumerize :awareness_raising_checkboxes, in: [
    :producer_transparency,
    :employee_transparency,
    :price_transparency,
    :responsible_consumption_education,
    :global_market_education,
    :fair_trade_concept,
    :other
  ], multiple: true

  # validates :awareness_raising, presence: true
  validates :awareness_raising_checkboxes, presence: true,
                                           if: :awareness_raising
  validates :awareness_raising_explanation, length: { minimum: 150, maximum: 10000 },
                                            if: :awareness_raising
  validates :awareness_raising_other, fair_trust_other: true
end
