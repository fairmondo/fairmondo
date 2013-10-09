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
module Article::Export
  extend ActiveSupport::Concern

  def self.export_articles(user, params = nil)
      # bugbug The horror...

      articles = determine_articles_to_export(user, params)

      header_row = ["title", "categories", "condition", "condition_extra",
                    "content", "quantity", "price_cents", "basic_price_cents",
                    "basic_price_amount", "vat", "external_title_image_url", "image_2_url",
                    "transport_pickup", "transport_type1",
                    "transport_type1_provider", "transport_type1_price_cents",
                    "transport_type2", "transport_type2_provider",
                    "transport_type2_price_cents", "transport_details",
                    "payment_bank_transfer", "payment_cash", "payment_paypal",
                    "payment_cash_on_delivery",
                    "payment_cash_on_delivery_price_cents", "payment_invoice",
                    "payment_details", "fair_kind", "fair_seal", "support",
                    "support_checkboxes", "support_other", "support_explanation",
                    "labor_conditions", "labor_conditions_checkboxes",
                    "labor_conditions_other", "labor_conditions_explanation",
                    "environment_protection", "environment_protection_checkboxes",
                    "environment_protection_other",
                    "environment_protection_explanation", "controlling",
                    "controlling_checkboxes", "controlling_other",
                    "controlling_explanation", "awareness_raising",
                    "awareness_raising_checkboxes", "awareness_raising_other",
                    "awareness_raising_explanation", "nonprofit_association",
                    "nonprofit_association_checkboxes",
                    "social_businesses_muhammad_yunus",
                    "social_businesses_muhammad_yunus_checkboxes",
                    "social_entrepreneur", "social_entrepreneur_checkboxes",
                    "social_entrepreneur_explanation", "ecologic_seal",
                    "upcycling_reason", "small_and_precious_eu_small_enterprise",
                    "small_and_precious_reason", "small_and_precious_handmade",
                    "gtin", "custom_seller_identifier"]

      CSV.generate(:col_sep => ";") do |line|
        # bugbug Refactor asap
        line << header_row
        articles.each do |article|
          row = Hash.new
          row.merge! (article.attributes)
          row.merge! (article.provide_fair_attributes)
          # row.merge! (article.fair_trust_questionnaire.attributes) if article.fair_trust_questionnaire
          # row.merge! (article.social_producer_questionnaire.attributes) if article.social_producer_questionnaire
          row["categories"] = article.categories.map { |a| a.id }.join(",")
          row["external_title_image_url"] = article.images.first.external_url if article.images.first
          row["image_2_url"] = article.images[1].external_url if article.images[1]
          line << header_row.map { |element| row[element] }
          # csv << article.attributes.values_at("title") +
          # [article.categories.map { |a| a.id }.join(",")] +
          # article.attributes.values_at(*header_row[2..9]) +
          # article.provide_external_urls +
          # article.attributes.values_at(*header_row[12..28]) +
          # create_fair_attributes(article, header_row) +
          # create_social_attributes(article, header_row) +
          # article.attributes.values_at(*header_row[56..-1])
        end
        # bugbug What about quotes used to escape eg semicolon ; ?
        line.string.gsub! "\"", ""
      end
    end

    def self.determine_articles_to_export(user, params)
      if params == "active"
        articles = user.articles.where(:state => "active")
        # Different reverse methods needed because adding two ActiveRecord::Relation objects leads to an Array
        articles.reverse_order
      elsif params == "inactive"
        articles = user.articles.where(:state => "preview") + user.articles.where(:state => "locked")
        # Different reverse methods needed because adding two ActiveRecord::Relation objects leads to an Array
        articles.reverse
      elsif params == "sold"
        articles = user.articles.where(:state => "sold")
        # Different reverse methods needed because adding two ActiveRecord::Relation objects leads to an Array
        articles.reverse_order
      elsif params == "bought"
        articles = user.bought_articles
        # Different reverse methods needed because adding two ActiveRecord::Relation objects leads to an Array
        articles.reverse_order
      else
        # bugbug Really needed?
        articles = user.articles
      end
    end

    # def self.create_fair_attributes(article, header_row)
    #   fair_attributes_raw_array = []
    #   fair_attributes = []
    #   if article.fair_trust_questionnaire
    #     fair_attributes_raw_array = article.fair_trust_questionnaire.attributes.values_at(*header_row[29..48])
    #     fair_attributes_raw_array.each do |element|
    #       if element.class == Array
    #         fair_attributes << element.join(',')
    #       else
    #         fair_attributes << element
    #       end
    #     end
    #   else
    #     20.times do
    #       fair_attributes << nil
    #     end
    #   end
    #   fair_attributes
    # end

    # def self.create_social_attributes(article, header_row)
    #   social_attributes_raw_array = []
    #   social_attributes = []
    #   if article.social_producer_questionnaire
    #     social_attributes_raw_array = article.social_producer_questionnaire.attributes.values_at(*header_row[49..55])
    #     social_attributes_raw_array.each do |element|
    #       if element.class == Array
    #         social_attributes << element.join(',')
    #       else
    #         social_attributes << element
    #       end
    #     end
    #   else
    #     7.times do
    #       social_attributes << nil
    #     end
    #   end
    #   social_attributes
    # end

    def provide_fair_attributes
      attributes = Hash.new
      if self.fair_trust_questionnaire
        attributes.merge! (self.fair_trust_questionnaire.attributes)
      end

      if self.social_producer_questionnaire
        attributes.merge! (self.social_producer_questionnaire.attributes)
      end
      attributes.each do |k, v|
        if k.include?("checkboxes")
          if v
            attributes[k] = v.join(',')
          else
            attributes[k] = nil
          end
        end
      end
      attributes
    end

    # def provide_external_urls
    #   external_urls = []
    #   unless self.images.empty?
    #     self.images.each do |image|
    #       external_urls << image.external_url
    #       break if external_urls.length == 2
    #     end
    #   end
    #   until external_urls.length == 2
    #     external_urls << nil
    #   end
    #   external_urls
    # end
end
