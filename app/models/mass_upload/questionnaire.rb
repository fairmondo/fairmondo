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
module MassUpload::Questionnaire
  extend ActiveSupport::Concern

  # Questionnaire.include_fair_questionnaires!(row_hash)

  def self.include_fair_questionnaires!(row_hash)
    ftq_attributes = FairTrustQuestionnaire.new.attributes
    ftq_attributes.except!(*["id", "article_id"])
    spq_attributes = SocialProducerQuestionnaire.new.attributes
    spq_attributes.except!(*["id", "article_id"])

    if row_hash["fair_kind"] == "fair_trust"
      row_hash["fair_trust_questionnaire_attributes"] = row_hash.extract!(*ftq_attributes.keys)
      transform_questionnaire_attributes(row_hash["fair_trust_questionnaire_attributes"])
    elsif row_hash["fair_kind"] == "social_producer"
      row_hash["social_producer_questionnaire_attributes"] = row_hash.extract!(*spq_attributes.keys)
      transform_questionnaire_attributes(row_hash["social_producer_questionnaire_attributes"])
    end
    row_hash.except! *(ftq_attributes.keys+spq_attributes.keys)
  end

  def self.transform_questionnaire_attributes(attributes)
    attributes.each do |k, v|
      if k.include?("checkboxes")
        if v
          attributes[k] = v.split(',')
        else
          attributes[k] = []
        end
      end
    end
  end

  def self.add_commendation(article)
    if article.fair_kind
      article.fair = true
    end
    if article.ecologic_seal
      article.ecologic = true
      article.ecologic_kind = "ecologic_seal"
    elsif article.upcycling_reason
      article.ecologic = true
      article.ecologic_kind = "upcycling"
    end
    if article.small_and_precious_eu_small_enterprise
      article.small_and_precious = true
    end
  end


  #   fair_trust_questionnaire_attributes_array = row[28..47]
  #   social_producer_questionnaire_attributes_array = row[48..54]
  #   fair_trust_questionnaire_attributes = {}
  #   social_producer_questionnaire_attributes = {}
  #   row = row - fair_trust_questionnaire_attributes_array - social_producer_questionnaire_attributes_array
  #   if row[26][1] == "fair_trust"
  #     key = "fair_trust_questionnaire_attributes"
  #     row = inject_questionnaire(fair_trust_questionnaire_attributes_array, fair_trust_questionnaire_attributes, row, key)
  #   elsif row[26][1] == "social_producer"
  #     key = "social_producer_questionnaire_attributes"
  #     row = inject_questionnaire(social_producer_questionnaire_attributes_array, social_producer_questionnaire_attributes, row, key)
  #   else
  #     row = Hash[row]
  #   end
  #   row
  # end

  # def inject_questionnaire (attributes_array, attributes_hash, row, key)
  #   attributes_array.each do |pair|
  #     if pair[0].include?("checkboxes") && pair[1..-1].first && pair[1..-1].first.split(',').length == 1
  #       attributes_hash[pair.first] = [""] + pair[1].split
  #     elsif pair[1..-1].first && cpair[1..-1].first.split(',').length > 1
  #       attributes_hash[pair.first] = [""] + pair[1..-1].join.delete(' ').split(',')
  #     else
  #       attributes_hash[pair.first] = pair[1..-1].first || [""]
  #     end
  #   end
  #   row = Hash[row]
  #   row[key] = attributes_hash
  #   row
  # end

end
