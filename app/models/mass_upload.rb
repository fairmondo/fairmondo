# encoding: utf-8
#
# Farinopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Farinopoly.
#
# Farinopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Farinopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Farinopoly.  If not, see <http://www.gnu.org/licenses/>.
#
class MassUpload

  # Required dependency for ActiveModel::Errors
  extend ActiveModel::Naming

  def initialize(attributes = nil, user)
    @errors = ActiveModel::Errors.new(self)
    if attributes && attributes[:file]
      @raw_articles = build_raw_articles(attributes[:file], user)
    else
      # bugbug Abuse of the symbol in the next line
      errors.add(:Bitte, "wähle eine CSV-Datei aus")
    end
  end

  attr_accessor :file
  attr_reader   :errors, :raw_articles

  def validate(file)
    unless csv_format?(file)
      # bugbug Abuse of the symbol in the next line
      errors.add(:Bitte, "wähle eine CSV-Datei aus")
      return false
    end
    unless correct_header?(file)
      # bugbug Abuse of the symbol in the next line
      errors.add(:Bei, "der ersten Zeile muss es sich um einen korrekten Header handeln")
      return false
    end
    true
  end

  def csv_format?(file)
    file && file.content_type == "text/csv" ? true : false
  end

  def correct_header?(file)
    header_row = ["title", "content", "condition", "price_cents",
                  "default_payment", "quantity", "default_transport",
                  "transport_details", "payment_details", "condition_extra",
                  "transport_pickup", "transport_insured",
                  "transport_uninsured", "transport_insured_provider",
                  "transport_uninsured_provider",
                  "transport_insured_price_cents",
                  "transport_uninsured_price_cents", "payment_bank_transfer",
                  "payment_cash", "payment_paypal", "payment_cash_on_delivery",
                  "payment_invoice", "payment_cash_on_delivery_price_cents",
                  "basic_price_cents", "basic_price_amount", "category_1",
                  "category_2", "vat", "currency"]
    CSV.foreach(file.path, headers: false) do |row|
      if row == header_row
        return true
      else
        return false
      end
    end
  end

  def build_raw_articles(file, user)
    if validate(file)
      raw_article_array = []
      rows_array = []
      categories = []
      user_id = user.id
      CSV.foreach(file.path, headers: true) do |row|
        rows_array << row.to_hash
      end

      rows_array.each do |row|
        categories << Category.find(row['category_1']) if row['category_1']
        categories << Category.find(row['category_2']) if row['category_2']
        row.delete("category_1")
        row.delete("category_2")
        article = Article.new(row)
        article.user_id = user_id
        article.categories = categories
        raw_article_array << article
      end
    end
    raw_article_array
  end

  def save
    raw_articles.each_with_index do |raw_article, index|
      raw_article.save
      if raw_article.errors.full_messages.any?
        raw_article.errors.full_messages.each do |message|
          errors.add(:Spalte, "#{message} (Artikelzeile #{index + 1})")
        end
      end
    end
  end

  # the following 3 methods are needed for Active Model Errors

  def read_attribute_for_validation(attr)
   send(attr)
  end

  def MassUpload.human_attribute_name(attr, options = {})
   attr
  end

  def MassUpload.lookup_ancestors
   [self]
  end

end