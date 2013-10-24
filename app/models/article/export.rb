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

  included do
    # Action attribute: c/create/u/update/d/delete - for export and csv upload
    attr_accessor :action
  end

  def self.export_articles(user, params = nil)
    header_row = MassUpload.expanded_header_row + ['€'] # Euro as UTF-8 identifier
    articles = determine_articles_to_export(user, params)

    CSV.generate(:col_sep => ";") do |line|
      line << header_row
      articles.each do |article|
        row = Hash.new
        row.merge!(article.attributes)
        row.merge!(article.provide_fair_attributes)
        row["categories"] = article.categories.map { |a| a.id }.join(",")
        row["external_title_image_url"] = article.images.first.external_url if article.images.first
        row["image_2_url"] = article.images[1].external_url if article.images[1]
        line << header_row.map { |element| row[element] }
      end
    end
  end

  def self.determine_articles_to_export(user, params)
    if params == "active"
      articles = user.articles.where(:state => "active")
      # Different reverse methods needed because adding two ActiveRecord::Relation objects leads to an Array
      articles.reverse_order
    elsif params == "inactive"
      articles = user.articles.where(:state => "preview") + user.articles.where(:state => "locked")
      articles.reverse
    elsif params == "sold"
      articles = user.articles.where(:state => "sold")
      articles.reverse_order
    elsif params == "bought"
      articles = user.bought_articles
      articles.reverse_order
      # bugbug Something needed in case no params are given?
    end
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
