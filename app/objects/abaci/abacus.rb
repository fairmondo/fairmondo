#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class Abacus
  attr_reader :line_item_group,
              :business_transaction_listing,
              :transport_listing,
              :payment_listing,
              :donation_listing,
              :total

  def initialize line_item_group
    @line_item_group = line_item_group
    @business_transaction_listing = BusinessTransactionAbacus.calculate line_item_group
    @transport_listing = TransportAbacus.calculate @business_transaction_listing
    @payment_listing = PaymentAbacus.calculate @business_transaction_listing, @transport_listing
    @donation_listing = DonationAbacus.calculate @line_item_group

    @total = calculate_total
  end

  def calculate_total
    @payment_listing.payments.map { |_payment, hash| hash[:total] }.sum
  end
end
