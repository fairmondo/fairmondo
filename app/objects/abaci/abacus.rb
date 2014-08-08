class Abacus

  attr_reader :business_transaction_listing, :transport_listing, :payment_listing, :total

  def initialize line_item_group
    @business_transaction_listing = BusinessTransactionAbacus.calculate line_item_group
    @transport_listing = TransportAbacus.calculate @business_transaction_listing
    @payment_listing = PaymentAbacus.calculate @business_transaction_listing, @transport_listing

    @total = calculate_total
  end

  def calculate_total
    @payment_listing.payments.map{ |payment,hash| hash[:total] }.sum
  end
end
