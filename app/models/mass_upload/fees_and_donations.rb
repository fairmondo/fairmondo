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
module MassUpload::FeesAndDonations
  extend ActiveSupport::Concern

  def self.calculate_total_fees(articles)
    total_fee = Money.new(0)
    articles.each do |article|
      total_fee += article.calculated_fee * article.quantity
    end
    total_fee
  end

  def self.calculate_total_fair(articles)
    total_fair = Money.new(0)
    articles.each do |article|
      total_fair += article.calculated_fair * article.quantity
    end
    total_fair
   end

  def self.calculate_total_fees_and_donations(articles)
    self.calculate_total_fees(articles) + self.calculate_total_fair(articles)
  end

  def self.calculate_total_fees_and_donations_netto(articles)
    total_netto = Money.new(0)
    articles.each do |article|
      total_netto += article.calculated_fees_and_donations_netto_with_quantity
    end
    total_netto
  end
end
