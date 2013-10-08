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
module MassUpload::Checks
  extend ActiveSupport::Concern

  def file_selected?
    if file
      return true
    else
      errors.add(:file, I18n.t('mass_upload.errors.missing_file'))
      return false
    end
  end

  def csv_format?
    if file.content_type == "text/csv"
      return true
    else
      errors.add(:file, I18n.t('mass_upload.errors.missing_file'))
      return false
    end
  end

  def correct_encoding_and_escaping?
    begin
      CSV.read(file.path, :encoding => 'utf-8', :col_sep => ";", :quote_char => '"')
    rescue ArgumentError
      errors.add(:file, I18n.t('mass_upload.errors.wrong_encoding'))
      return false
    rescue CSV::MalformedCSVError
      errors.add(:file, I18n.t('mass_upload.errors.illegal_quoting'))
      return false
    end
  end

  def correct_article_count?
    if CSV.read(file.path, :col_sep => ";", :quote_char => '"').size < 102
      return true
    else
      errors.add(:file, I18n.t('mass_upload.errors.wrong_file_size'))
      return false
    end
  end

  def correct_header?
    header_row = ["title;categories;condition;condition_extra;content;quantity;price_cents;basic_price_cents;basic_price_amount;vat;external_title_image_url;image_2_url;transport_pickup;transport_type1;transport_type1_provider;transport_type1_price_cents;transport_type2;transport_type2_provider;transport_type2_price_cents;transport_details;payment_bank_transfer;payment_cash;payment_paypal;payment_cash_on_delivery;payment_cash_on_delivery_price_cents;payment_invoice;payment_details;fair_kind;fair_seal;support;support_checkboxes;support_other;support_explanation;labor_conditions;labor_conditions_checkboxes;labor_conditions_other;labor_conditions_explanation;environment_protection;environment_protection_checkboxes;environment_protection_other;environment_protection_explanation;controlling;controlling_checkboxes;controlling_other;controlling_explanation;awareness_raising;awareness_raising_checkboxes;awareness_raising_other;awareness_raising_explanation;nonprofit_association;nonprofit_association_checkboxes;social_businesses_muhammad_yunus;social_businesses_muhammad_yunus_checkboxes;social_entrepreneur;social_entrepreneur_checkboxes;social_entrepreneur_explanation;ecologic_seal;upcycling_reason;small_and_precious_eu_small_enterprise;small_and_precious_reason;small_and_precious_handmade;gtin;custom_seller_identifier"]

    CSV.foreach(file.path, headers: false) do |row|
      if row == header_row
        return true
      else
        errors.add(:file, I18n.t('mass_upload.errors.wrong_header'))
        return false
      end
    end
  end
end
