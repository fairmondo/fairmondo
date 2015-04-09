#
#
# == License:
# Fairmondo - Fairmondo is an open-source online marketplace.
# Copyright (C) 2013 Fairmondo eG
#
# This file is part of Fairmondo.
#
# Fairmondo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairmondo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairmondo.  If not, see <http://www.gnu.org/licenses/>.
#
module Article::FeesAndDonations
  extend ActiveSupport::Concern

  TRANSACTION_FEES = {
    min: 10,
    max_fair: 1_500,
    max_default: 3_000,
    fair: 0.03,
    default: 0.06
  }

  included do
    before_create :set_friendly_percent_for_ngo, if: :seller_ngo

    # Fees and donations
    monetize :calculated_fair_cents, allow_nil: true
    monetize :calculated_friendly_cents, allow_nil: true
    monetize :calculated_fee_cents, allow_nil: true

    ## friendly percent
    validates_presence_of :friendly_percent_organisation_id, if: :friendly_percent_gt_0?
    validates_presence_of :friendly_percent
  end

  ## -------------- Calculate Fees And Donations ---------------

  def could_be_book_price_agreement?
    book_category_id = $exceptions_on_fairmondo['book_price_agreement']['category'].to_i
    is_a_book = categories.map { |c| c.self_and_ancestors.map(&:id) }.flatten.include? book_category_id
    is_a_book && condition == 'new'
  end

  def calculated_fees_and_donations
    calculated_fair + calculated_friendly + calculated_fee
  end

  def calculated_fees_and_donations_with_quantity
    calculated_fees_and_donations * quantity
  end

  def calculated_fees_and_donations_netto
    fee_cents = calculated_fair_cents + calculated_friendly_cents + calculated_fee_cents
    netto = Money.new((fee_cents / 1.19).ceil)
    netto
  end

  def calculated_fees_and_donations_netto_with_quantity
    calculated_fees_and_donations_netto * quantity
  end

  def calculate_fees_and_donations
    self.calculated_friendly = Money.new(friendly_percent_result_cents)
    if friendly_percent < 100 && price > 0
      self.calculated_fair = fair_percent_result
      self.calculated_fee = fee_result
    else
      self.calculated_fair = 0
      self.calculated_fee = 0
    end
  end

  private

  def friendly_percent_gt_0?
    friendly_percent.present? &&
    friendly_percent > 0
  end

  def set_friendly_percent_for_ngo
    if seller.ngo
      self.friendly_percent = 100
      self.friendly_percent_organisation_id = seller.id
    end
  end

  def friendly_percent_result_cents
    # At the moment there is no friendly percent
    # for rounding -> always round up (e.g. 900,1 cents are 901 cents)
    # (price_cents * (friendly_percent / 100.0)).ceil
    # NGOs are not allowed to give donation to other NGO
    seller.ngo ? 0 : (price_cents * (friendly_percent / 100.0)).ceil
  end

  ## fees and donations

  def fair_percentage
    seller.ngo ? 0 : 0.01
  end

  def fair_percent_result
    # for rounding -> always round up (e.g. 900,1 cents are 901 cents)
    Money.new(((price_cents - friendly_percent_result_cents) * fair_percentage).ceil)
  end

  def fee_percentage
    return 0 if seller.ngo
    return TRANSACTION_FEES[:fair] if fair?
    TRANSACTION_FEES[:default]
  end

  def fee_result
    result = 0
    result = fee_for_article unless seller.ngo
    result
  end

  def fee_for_article
    result = actual_fee
    result = min_fee if result < min_fee
    result = max_fee if result > max_fee
    result
  end

  def actual_fee
    # for rounding -> always round up (e.g. 900,1 cents are 901 cents)
    Money.new(((price_cents - friendly_percent_result_cents) * fee_percentage).ceil)
  end

  def max_fee
    Money.new(fair? ? TRANSACTION_FEES[:max_fair] : TRANSACTION_FEES[:max_default])
  end

  def min_fee
    Money.new(TRANSACTION_FEES[:min])
  end
end
