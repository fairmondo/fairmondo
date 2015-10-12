#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module MassUpload::Questionnaire
  extend ActiveSupport::Concern

  FTQ_ATTRIBUTES = FairTrustQuestionnaire.column_names - %w(id article_id)
  SPQ_ATTRIBUTES = SocialProducerQuestionnaire.column_names - %w(id article_id)

  def self.include_fair_questionnaires(attributes)
    ftq = attributes.extract!(*FTQ_ATTRIBUTES)
    spq = attributes.extract!(*SPQ_ATTRIBUTES)
    if attributes['fair_kind'] == 'fair_trust'
      attributes['fair_trust_questionnaire_attributes'] = deserialize_checkboxes(ftq)
    elsif attributes['fair_kind'] == 'social_producer'
      attributes['social_producer_questionnaire_attributes'] = deserialize_checkboxes(spq)
    end
  end

  def self.deserialize_checkboxes(attributes)
    attributes.each do |k, v|
      if k.include?('checkboxes')
        if v
          attributes[k] = v.split(',').map { |i| i.strip } # strip needed to inculde not just the first element because of white space
        else
          attributes[k] = []
        end
      end
    end
    attributes
  end

  def self.add_commendation(attributes)
    if attributes['fair_kind'].present?
      attributes['fair'] = true
    end
    if attributes['ecologic_seal'].present?
      attributes['ecologic'] = true
      attributes['ecologic_kind'] = 'ecologic_seal'
    elsif attributes['upcycling_reason'].present?
      attributes['ecologic'] = true
      attributes['ecologic_kind'] = 'upcycling'
    end
    if attributes['small_and_precious_eu_small_enterprise'] && attributes['small_and_precious_eu_small_enterprise'] == 'true'
      attributes['small_and_precious'] = true
    end
  end
end
