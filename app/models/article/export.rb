# encoding: UTF-8
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
module Article::Export
  extend ActiveSupport::Concern

  def self.export_erroneous_articles(erroneous_articles)
    csv = CSV.generate_line(MassUpload.article_attributes, :col_sep => ";")
    erroneous_articles.each do |article|
      csv += article.article_csv
    end
    csv
  end


  def provide_fair_attributes
    attributes = Hash.new
    if self.fair_trust_questionnaire
      attributes.merge!(self.fair_trust_questionnaire.attributes)
    end

    if self.social_producer_questionnaire
      attributes.merge!(self.social_producer_questionnaire.attributes)
    end
    serialize_checkboxes(attributes)
  end

  def serialize_checkboxes(attributes)
    attributes.each do |k, v|
      if k.include?("checkboxes")
        if v.any?
          attributes[k] = v.join(',')
        else
          attributes[k] = nil
        end
      end
    end
    attributes
  end
end
