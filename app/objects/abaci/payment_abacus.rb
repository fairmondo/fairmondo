class PaymentAbacus

  UNIFIED_TRANSPORT_PAYMENT_ORDER = [:cash_on_delivery, :paypal, :invoice, :bank_transfer]
  UNIFIED_TRANSPORT_PAYMENT_ORDER_MERGED = (UNIFIED_TRANSPORT_PAYMENT_ORDER + Article::PAYMENT_TYPES).uniq
  attr_reader :payments

  def self.calculate business_transaction_abacus, transport_abacus
    abacus = PaymentAbacus.new(business_transaction_abacus,transport_abacus)
    abacus.calculate_payments
    abacus
  end

  def calculate_payments
    unified_transport_payment = @line_item_group.unified_transport ? get_unified_transport_payment_method : nil
    @business_transaction_abacus.by_payment.map do |payment,bts|
      initialize_payment payment, bts
      add_single_transports_to_payment payment, bts
      add_unified_transport_to_payment payment if unified_transport_payment == payment
      calculate_costs payment
    end

  end

  private
    def initialize business_transaction_abacus,transport_abacus

      @line_item_group = business_transaction_abacus.line_item_group
      @business_transaction_abacus = business_transaction_abacus
      @transport_abacus = transport_abacus
      @payments = {}
    end

    def get_unified_transport_payment_method
      available_payments = @business_transaction_abacus.by_payment.keys

      UNIFIED_TRANSPORT_PAYMENT_ORDER_MERGED.each do |payment|
        return payment if available_payments.include? payment
      end
    end

    def initialize_payment payment, bts
      @payments[payment] = { business_transactions: bts }
      @payments[payment][:transports] ||= []
    end

    def add_single_transports_to_payment payment, business_transactions

      business_transactions.each do |bt|
        transport = @transport_abacus.single_transports[bt]
        @payments[payment][:transports] << transport if transport
      end
    end

    def add_unified_transport_to_payment payment
      @payments[payment][:transports] << @transport_abacus.unified_transport
    end

    def calculate_costs payment
      if payment == :cash_on_delivery
        @payments[payment][:cash_on_delivery_total] = calculate_attribute_total :cash_on_delivery, :cash_on_delivery
      end
      @payments[payment][:transport_total] = calculate_attribute_total payment, :price
      @payments[payment][:total] = calculate_total payment
    end

    def calculate_attribute_total payment, attribute
      @payments[payment][:transports].map{ |h| h[attribute] || Money.new(0) }.sum
    end

    def calculate_total payment
      total = @payments[payment][:business_transactions].map{ |bt| @business_transaction_abacus.prices[bt][:retail_price] }.sum
      total += @payments[payment][:transport_total]
      total += @payments[payment][:cash_on_delivery_total] if payment == :cash_on_delivery
      total
    end
end
