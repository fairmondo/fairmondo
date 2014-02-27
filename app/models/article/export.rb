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

  def self.export_articles(csv,user, params = nil)

    # Generate proper headers and find out if we are messing with transactions
    export_attributes = MassUpload.article_attributes
    transactions = false

    if params == "sold"
      export_attributes += MassUpload.transaction_attributes
      transactions = true
    end

    #write the headers and set options for csv generation
    options = { :col_sep => ";" }
    csv.puts CSV.generate_line export_attributes, options


    determine_articles_to_export(user, params).find_each do |item|
      article = item

      if item.is_a? Transaction
        article = item.article
      end

      row = Hash.new
      row.merge!(article.provide_fair_attributes)
      row.merge!(article.attributes)
      row["categories"] = article.categories.map { |c| c.id }.join(",")
      row["external_title_image_url"] = article.images.first.external_url if article.images.first
      row["image_2_url"] = article.images[1].external_url if article.images[1]
      if item.is_a? Transaction
        fee = article.calculated_fee_cents * item.quantity_bought
        donation = article.calculated_fair_cents * item.quantity_bought
        transaction_information = { "transport_provider" => item.selected_transport_provider,
                                    "sales_price_cents" => article.price_cents * item.quantity_bought,
                                    "price_without_vat_cents" => (article.price_without_vat.to_d * 100).to_i,
                                    "vat_cents" => (article.vat_price.to_d * 100).to_i,
                                    "shipping_and_handling_cents" => (item.article_transport_price(item.selected_transport, item.quantity_bought).to_d * 100).to_i,
                                    "buyer_email" => item.buyer_email,
                                    "fee_cents" => fee,
                                    "donation_cents" => donation,
                                    "total_fee_cents" => (fee + donation),
                                    "net_total_fee_cents" => ((fee + donation) / 1.19).round(0),
                                    "vat_total_fee_cents" => ((fee + donation) * 0.19).round(0)}
        row.merge!(transaction_information)
        buyer_information = item.attributes.slice(*MassUpload.transaction_attributes)
        row.merge!(buyer_information)
      end
      csv.puts CSV.generate_line export_attributes.map { |element| row[element] }, options

    end
    csv.flush
  end

  def self.export_erroneous_articles(erroneous_articles)
    csv = CSV.generate_line(MassUpload.article_attributes, :col_sep => ";")
    erroneous_articles.each do |article|
      csv += article.article_csv
    end
    csv
  end

  def self.determine_articles_to_export(user, params)
    if params == "active"
      user.articles.where(:state => "active").order("created_at ASC").includes(:images,:categories,:social_producer_questionnaire,:fair_trust_questionnaire)
    elsif params == "inactive"
      user.articles.where("state = ? OR state = ?","preview","locked").order("created_at ASC").includes(:images,:categories,:social_producer_questionnaire,:fair_trust_questionnaire)
    elsif params == "sold"
      user.sold_transactions.joins(:article)
    elsif params == "bought"
      user.bought_articles
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