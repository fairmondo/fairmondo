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
      total = Money.new(0)
      articles.each do |article|
        total += article.send("calculated_#{type.to_s.singularize}") * article.quantity
      end
      total
    end
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
