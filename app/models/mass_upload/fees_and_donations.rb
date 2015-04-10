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
module MassUpload::FeesAndDonations
  extend ActiveSupport::Concern

  # method for calculation of fee or fair percent
  [:fees, :fair].each do |type|
    define_singleton_method("calculate_total_#{type}") do |articles|
      Money.new(articles.sum("calculated_#{type.to_s.singularize}_cents * quantity"))
    end
  end

  def self.calculate_total_fees_and_donations(articles)
    self.calculate_total_fees(articles) + self.calculate_total_fair(articles)
  end

  def self.calculate_total_fees_and_donations_netto(articles)
    fees_and_donations = articles.pluck(:calculated_fair_cents, :calculated_friendly_cents, :calculated_fee_cents, :quantity)
    Money.new(fees_and_donations.map { |values| ((values[0] + values[1] + values[2]) / 1.19).ceil * values[3] }.sum)
  end
end
