# encoding: utf-8
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
class MassUpload

  # Required for Active Model Conversion which is required by Formtastic
  include ActiveModel::Conversion

  # Required dependency for ActiveModel::Errors
  extend ActiveModel::Naming

  def initialize(user, attributes = nil)
    @errors = ActiveModel::Errors.new(self)
    # To check if there are attributes at all (for rendering the new view) and
    # to check if any file was selected
    if attributes && attributes[:file]
      @raw_articles = build_raw_articles(user, attributes[:file])
    end
  end

  attr_accessor :file
  attr_reader   :errors, :raw_articles

  def validate_input(file)
    # Needed for the 'stand alone' validation since we don't know if
    # params[:mass_upload] == nil or not and therefore can't use
    # params[:mass_upload][:file]
    if file.class == ActiveSupport::HashWithIndifferentAccess
      file = file[:file]
    end

    unless csv_format?(file)
      errors.add(:file, I18n.t('mass_upload.errors.missing_file'))
      return false
    end

    unless correct_header?(file)
      errors.add(:file, I18n.t('mass_upload.errors.wrong_header'))
      return false
    end
    true
  end

  def validate_articles(articles)
    valid = true
    raw_articles.each_with_index do |raw_article, index|
      unless raw_article.valid?
        raw_article.errors.full_messages.each do |message|
          errors.add(:file, I18n.t('mass_upload.errors.wrong_article', message: message, index: (index + 1)))
        end
        valid = false
      end
    end
    valid
  end

  def csv_format?(file)
    file && file.content_type == "text/csv" ? true : false
  end

  def correct_header?(file)
    true
    header_row = ["Artikelbezeichnung", "Artikelbeschreibung", "Kategorie 1",
                  "Kategorie 2", "Grundpreis in Cent", "Mengeneinheit",
                  "Artikelzustand", "Zustandsbeschreibung", "Preis in Cent",
                  "Umsatzsteuer", "Waehrung", "Anzahl (verfuegbar)",
                  "Standardversand", "Selbstabholung", "Versicherter Versand",
                  "Versandart (versichert)", "Versankosten in Cent (vesichert)",
                  "Unversicherter Versand", "Versandart (unversichert)",
                  "Versankosten in Cent (unversichert)",
                  "Weitere Angaben (Versand)", "Standardbezahlmethode",
                  "Ueberweisung (Vorkasse)", "Barzahlung bei Abholung",
                  "PayPal", "Nachnahme",
                  "Nachnahmezuschlag in Cent", "Rechnung",
                  "Weitere Angaben (Bezahlmethode)"]

    CSV.foreach(file.path, headers: false) do |row|
      if row == header_row
        return true
      else
        return false
      end
    end
  end

  def missing_bank_details_errors(current_user)
    if self.errors[:file].grep(/Seller bank/).any?
      self.errors.clear

      errors.add(:file, I18n.t('mass_upload.errors.missing_bank_details', :link => Rails.application.routes.url_helpers.edit_user_registration_path(current_user)))
    end
  end

  def build_raw_articles(user, file)
    header_translation = { "Artikelbezeichnung" => "title",
                           "Artikelbeschreibung" => "content",
                           "Artikelzustand" => "condition",
                           "Zustandsbeschreibung" => "condition_extra",
                           "Preis in Cent" => "price_cents",
                           "Anzahl (verfuegbar)" => "quantity",
                           "Standardversand" => "default_transport",
                           "Selbstabholung" => "transport_pickup",
                           "Versicherter Versand" => "transport_insured",
                           "Versandart (versichert)" => "transport_insured_provider",
                           "Versankosten in Cent (vesichert)" => "transport_insured_price_cents",
                           "Unversicherter Versand" => "transport_uninsured",
                           "Versandart (unversichert)" => "transport_uninsured_provider",
                           "Versankosten in Cent (unversichert)" => "transport_uninsured_price_cents",
                           "Weitere Angaben (Versand)" => "transport_details",
                           "Standardbezahlmethode" => "default_payment",
                           "Ueberweisung (Vorkasse)" => "payment_bank_transfer",
                           "Kontoinhaber" => "bank_account_owner",
                           "Bankleitzahl" => "bank_code",
                           "Name der Bank" => "bank_name" ,
                           "Kontonummer" => "bank_account_number",
                           "Barzahlung bei Abholung" => "payment_cash",
                           "PayPal" => "payment_paypal",
                           "PayPal-Konto" => "paypal_account",
                           "Nachnahme" => "payment_cash_on_delivery",
                           "Rechnung" => "payment_invoice",
                           "Nachnahmezuschlag in Cent" => "payment_cash_on_delivery_price_cents",
                           "Weitere Angaben (Bezahlmethode)" => "payment_details",
                           "Grundpreis in Cent" => "basic_price_cents",
                           "Mengeneinheit" => "basic_price_amount",
                           "Kategorie 1" => "category_1",
                           "Kategorie 2" => "category_2",
                           "Umsatzsteuer" => "vat",
                           "Waehrung" => "currency"}

    if validate_input(file)
      raw_article_array = []
      rows_array = []
      categories = []
      user_id = user.id
      CSV.foreach(file.path, headers: true) do |row|
        rows_array << row.to_hash
      end

      rows_array.each do |row|
        categories << Category.find(row['Kategorie 1']) if row['Kategorie 1']
        categories << Category.find(row['Kategorie 2']) if row['Kategorie 2']
        row.delete("Kategorie 1")
        row.delete("Kategorie 2")
        row = Hash[row.map {|k, v| [header_translation[k], v] }]
        article = Article.new(row)
        article.user_id = user_id
        article.categories = categories
        raw_article_array << article
      end
    end
    raw_article_array
  end

  def save
    if validate_articles(raw_articles)
      raw_articles.each do |raw_article|
        raw_article.save
      end
    end
  end

  # The following 3 methods are needed for Active Model Errors

  def MassUpload.human_attribute_name(attr, options = {})
   attr
  end

  # The following 2 are not currently used but might be needed because of Active
  # Model Errors in the future. They are commented out to make sure the test
  # coverage can reach 100%
  # def read_attribute_for_validation(attr)
  #  send(attr)
  # end

  # def MassUpload.lookup_ancestors
  #  [self]
  # end

  # The following method is needed for Active Model Conversions
  def persisted?
    false
  end

end
