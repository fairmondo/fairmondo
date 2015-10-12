#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

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
