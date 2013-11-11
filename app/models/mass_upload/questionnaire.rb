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

  def self.include_fair_questionnaires(row_hash)
    ftq_attributes = FairTrustQuestionnaire.new.attributes
    ftq_attributes.except!(*["id", "article_id"])
    spq_attributes = SocialProducerQuestionnaire.new.attributes
    spq_attributes.except!(*["id", "article_id"])
    ftq = row_hash.extract!(*ftq_attributes.keys)
    spq = row_hash.extract!(*spq_attributes.keys)

    if row_hash["fair_kind"] == "fair_trust"
      row_hash["fair_trust_questionnaire_attributes"] = deserialize_checkboxes(ftq)
    elsif row_hash["fair_kind"] == "social_producer"
      row_hash["social_producer_questionnaire_attributes"] = deserialize_checkboxes(spq)
    end
    row_hash
  end

  def self.deserialize_checkboxes(attributes)
    attributes.each do |k, v|
      if k.include?("checkboxes")
        if v
          attributes[k] = v.split(',').map{|i| i.strip} # strip needed to inculde not just the first element because of white space
        else
          attributes[k] = []
        end
      end
    end
    attributes
  end

  def self.add_commendation(attributes)
    if attributes["fair_kind"]
      attributes["fair"] = true
    end
    if attributes["ecologic_seal"]
      attributes["ecologic"] = true
      attributes["ecologic_kind"] = "ecologic_seal"
    elsif attributes["upcycling_reason"]
      attributes["ecologic"] = true
      attributes["ecologic_kind"] = "upcycling"
    end
    if attributes["small_and_precious_eu_small_enterprise"] && attributes["small_and_precious_eu_small_enterprise"] == "true"
      attributes["small_and_precious"] = true
    end
    return attributes
  end
end
