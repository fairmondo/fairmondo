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
class SocialProducerQuestionnaire < ActiveRecord::Base
  extend Enumerize
  extend Sanitization


  # def self.questionnaire_attrs
  #   [:nonprofit_association, {nonprofit_association_checkboxes:[]},
  #   :social_businesses_muhammad_yunus,
  #   {social_businesses_muhammad_yunus_checkboxes:[]},
  #   :social_entrepreneur, {social_entrepreneur_checkboxes:[]},
  #   :social_entrepreneur_explanation]
  # end

  auto_sanitize :social_entrepreneur_explanation

  belongs_to :article

  def initialize(*args)
    if args.present?
      args[0].select{|k,v| k.match(/_checkboxes$/)}.each_pair do |k, v|
        args[0][k] = v.reject(&:empty?)
      end
    end
    super
  end

  # Validations

  validate :is_social_producer

  validates :nonprofit_association_checkboxes, :size => {:in => 1..-1}, :if => :nonprofit_association?
  validates :social_businesses_muhammad_yunus_checkboxes, :size => {:in => 1..-1}, :if => :social_businesses_muhammad_yunus?
  validates :social_entrepreneur_checkboxes, :size => {:in => 1..-1}, :if => :social_entrepreneur?
  validates :social_entrepreneur_explanation, length: {minimum: 150, maximum: 10000},
                                            if: :social_entrepreneur?
  validates_presence_of :social_entrepreneur_explanation, :if => :social_entrepreneur?


  serialize :nonprofit_association_checkboxes, Array
  enumerize :nonprofit_association_checkboxes, :in => [
    :youth_and_elderly,
    :art_and_culture,
    :national_and_vocational_training,
    :natural_protection,
    :charity,
    :persecuted_minorities_and_victims_of_persecution,
    :international_tolerance,
    :animal_protection,
    :development_cooperation,
    :consumer_protection,
    :convicts_and_ex_convicts,
    :sexual_equality,
    :democratic_political_system
  ], :multiple => true

  serialize :social_businesses_muhammad_yunus_checkboxes, Array
  enumerize :social_businesses_muhammad_yunus_checkboxes, :in =>  [
    :social_proplem,
    :dividend,
    :reinvestment,
    :natural_protection,
    :conditions_of_work
  ], :multiple => true

  serialize :social_entrepreneur_checkboxes, Array
  enumerize :social_entrepreneur_checkboxes, :in => [
    :social_proplem,
    :big_social_groups,
    :small_social_groups,
    :generally_charitable,
    :potential_social_advancement,
    :social_sensitization
  ], :multiple => true


  def is_social_producer
    unless (self.nonprofit_association? || self.social_businesses_muhammad_yunus? || self.social_entrepreneur?)
      errors.add(:base,I18n.t('article.form.errors.social_producer_questionnaire.no_social_producer'))
    end
  end

end
