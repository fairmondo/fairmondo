class TransportAbacus
  attr_reader :single_transports, :unified_transport, :free_transport, :free_transport_at_price

  def self.calculate business_transaction_abacus
    abacus = TransportAbacus.new(business_transaction_abacus)
    abacus.check_free_transport
    abacus.calculate_single_transports
    abacus.calculate_unified_transport if business_transaction_abacus.line_item_group.unified_transport?
    abacus
  end

  def check_free_transport
    @free_transport_at_price = @line_item_group.free_transport_at_price
    @free_transport = ( @free_transport_at_price &&  @business_transaction_abacus.total_retail_price >= @free_transport_at_price )
  end

  def calculate_single_transports
    result = @business_transaction_abacus.single_transports.map do |bt|
      [bt,calculate_single_transport_for(bt)]
    end
    @single_transports = result.to_h
  end

  def calculate_unified_transport
    number_of_items = @business_transaction_abacus.unified_transport.map(&:quantity_bought).sum
    shipments = self.class.number_of_shipments(number_of_items, @line_item_group.unified_transport_maximum_articles)
    transport_price = transport_price_for(@line_item_group.unified_transport_price, shipments)
    total_retail_price = @business_transaction_abacus.unified_transport.map{ |bt| retail_price(bt)}.sum
    @unified_transport = {
      method: :unified,
      business_transactions: @business_transaction_abacus.unified_transport,
      provider: @line_item_group.unified_transport_provider,
      shipments: shipments,
      per_shipment: @line_item_group.unified_transport_price,
      transport_price: transport_price,
      total: total_retail_price + transport_price
    }
  end


  private
    def initialize business_transaction_abacus
      @line_item_group = business_transaction_abacus.line_item_group
      @business_transaction_abacus = business_transaction_abacus
    end

    def calculate_single_transport_for bt
      single_transport_price, transport_number = bt.article.transport_details_for bt.selected_transport.to_sym
      shipments = self.class.number_of_shipments(bt.quantity_bought, transport_number)
      transport_price = transport_price_for(single_transport_price, shipments)
      cash_on_delivery_price = self.class.cash_on_delivery_price(bt, shipments)
      total = retail_price(bt) + transport_price + ( cash_on_delivery_price || Money.new(0) )
      {
        method: bt.selected_transport.to_sym,
        provider: bt.article.transport_provider(bt.selected_transport),
        shipments: shipments,
        per_shipment: single_transport_price,
        transport_price: transport_price,
        cash_on_delivery: cash_on_delivery_price,
        total: total
      }
    end

    def transport_price_for single_transport_price, number_of_shipments
      @free_transport ? Money.new(0) : (single_transport_price * number_of_shipments)
    end

    def self.number_of_shipments quantity, maximum_per_shipment
      return 0 if maximum_per_shipment == 0
      quantity.fdiv(maximum_per_shipment).ceil
    end

    def self.cash_on_delivery_price business_transaction, number_of_shipments
      return nil unless business_transaction.selected_payment.cash_on_delivery?
      business_transaction.article_payment_cash_on_delivery_price * number_of_shipments
    end

    def retail_price business_transaction
      @business_transaction_abacus.prices[business_transaction][:retail_price]
    end



end
