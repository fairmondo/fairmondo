#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class SocialProducerQuestionnaire < ActiveRecord::Base
  extend Enumerize
  extend Sanitization
  include QuestionnaireInitializer

  auto_sanitize :social_entrepreneur_explanation

  belongs_to :article

  # Validations

  validate :is_social_producer

  validates :nonprofit_association_checkboxes, size: { in: 1..-1 }, if: :nonprofit_association?
  validates :social_businesses_muhammad_yunus_checkboxes, size: { in: 1..-1 }, if: :social_businesses_muhammad_yunus?
  validates :social_entrepreneur_checkboxes, size: { in: 1..-1 }, if: :social_entrepreneur?
  validates :social_entrepreneur_explanation, length: { minimum: 150, maximum: 10000 },
                                              if: :social_entrepreneur?
  validates :social_entrepreneur_explanation, presence: true, if: :social_entrepreneur?

  serialize :nonprofit_association_checkboxes, Array
  enumerize :nonprofit_association_checkboxes, in: [
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
  ], multiple: true

  serialize :social_businesses_muhammad_yunus_checkboxes, Array
  enumerize :social_businesses_muhammad_yunus_checkboxes, in: [
    :social_proplem,
    :dividend,
    :reinvestment,
    :natural_protection,
    :conditions_of_work
  ], multiple: true

  serialize :social_entrepreneur_checkboxes, Array
  enumerize :social_entrepreneur_checkboxes, in: [
    :social_proplem,
    :big_social_groups,
    :small_social_groups,
    :generally_charitable,
    :potential_social_advancement,
    :social_sensitization
  ], multiple: true

  def is_social_producer
    unless (self.nonprofit_association? || self.social_businesses_muhammad_yunus? || self.social_entrepreneur?)
      errors.add(:base, I18n.t('article.form.errors.social_producer_questionnaire.no_social_producer'))
    end
  end
end
