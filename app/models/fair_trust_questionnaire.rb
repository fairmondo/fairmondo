#
#
# == License:
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
class FairTrustQuestionnaire < ActiveRecord::Base
  extend Enumerize
  extend Sanitization

  def self.questionnaire_attrs
    [
      # Question 1: supports marginalized workers (req)
      :support, :support_explanation, :support_other, {support_checkboxes:[]},
      # Question 2: labor conditions acceptable? (req)
      :labor_conditions, {labor_conditions_checkboxes:[]},
      :labor_conditions_explanation, :labor_conditions_other,
      # Question 3: is production environmentally friendly (opt)
      :environment_protection, {environment_protection_checkboxes:[]},
      :environment_protection_explanation, :environment_protection_other,
      # Question 4: does controlling of these standards exist (req)
      :controlling, {controlling_checkboxes:[]}, :controlling_explanation,
      :controlling_other,
      # Question 5: awareness raising programs supported? (opt)
      :awareness_raising, {awareness_raising_checkboxes:[]},
      :awareness_raising_explanation, :awareness_raising_other
    ]
  end

  # def self.questionnaire_keys
  #   self.questionnaire_attrs.map { |key| key.is_a?(Hash) ? key.keys.first : key }
  # end


  auto_sanitize :support_explanation, :support_other,
                :labor_conditions_explanation, :labor_conditions_other,
                :environment_protection_explanation, :environment_protection_other,
                :controlling_explanation, :controlling_other,
                :awareness_raising_explanation, :awareness_raising_other

  belongs_to :article

  # Whoever wrote this method - please document and write tests for it
  def initialize(*args)
    if args.present?
      args[0].select{|k,v| k.match(/_checkboxes$/)}.each_pair do |k, v|
        args[0][k] = v.reject(&:empty?)
      end
    end
    super
  end

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
  ], multiple: true

  validates :support, presence: true
  validates :support_checkboxes, presence: true,
                                 size: {in: 3..-1},
                                 if: :support
  validates :support_explanation, presence: true,
                                  length: {minimum: 150, maximum: 10000},
                                  if: :support
  validates :support_other, presence: true,
                            length: {minimum: 5, maximum: 100},
                            if: lambda { |i| i.other_selected?("support") }

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
  ], multiple: true

  validates :labor_conditions, presence: true
  validates :labor_conditions_checkboxes, presence: true,
                                          size: {in: 4..-1},
                                          if: :labor_conditions
  validates :labor_conditions_explanation, presence: true,
                                           length: {minimum: 150 , maximum: 10000},
                                           if: :labor_conditions
  validates :labor_conditions_other, presence: true,
                                     length: {minimum: 5, maximum: 100},
                                     if: lambda { |i| i.other_selected?("labor_conditions") }

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
  ], multiple: true

  #validates :environment_protection, presence: true
  validates :environment_protection_checkboxes, presence: true,
                                                if: :environment_protection
  validates :environment_protection_explanation, length: {minimum: 150, maximum: 10000},
                                                 if: :environment_protection
  validates :environment_protection_other, presence: true,
                                           length: {minimum: 5, maximum: 100},
                                           if: lambda { |i| i.other_selected?("environment_protection") }

  # Q4

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
                                     size: {in: 2..-1}, if: :controlling
  validates :controlling_explanation, presence: true,
                                      length: {minimum: 150, maximum: 10000},
                                      if: :controlling
  validates :controlling_other, presence: true,
                                length: {minimum: 5, maximum: 100},
                                if: lambda { |i| i.other_selected?("controlling") }

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
  ], multiple: true

  #validates :awareness_raising, presence: true
  validates :awareness_raising_checkboxes, presence: true,
                                           if: :awareness_raising
  validates :awareness_raising_explanation, length: {minimum: 150, maximum: 10000},
                                            if: :awareness_raising
  validates :awareness_raising_other, presence: true,
                                      length: {minimum: 5, maximum: 100},
                                      if: lambda { |i| i.other_selected?("awareness_raising") }


  # Checks if a _checkboxes field has "other" selected
  # @param field [String] one of he currently five field names
  def other_selected? field
    self.send("#{field}_checkboxes").include? :other
  end
end
