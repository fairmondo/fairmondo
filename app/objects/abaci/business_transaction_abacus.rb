class BusinessTransactionAbacus

  attr_reader :prices,
  :by_payment,
  :single_transports,
  :unified_transport,
  :total_retail_price,
  :line_item_group

  def self.calculate line_item_group
     abacus = BusinessTransactionAbacus.new(line_item_group)
     abacus.prepare_and_sort_business_transactions
     abacus.calculate_total_retail_price
     abacus
  end

  def prepare_and_sort_business_transactions
    line_item_group.business_transactions.each do |bt|

      @prices[bt] = self.class.prices_of(bt)

      prepare_transport_for bt
      prepare_payment_for bt

    end
  end

  def calculate_total_retail_price
    @total_retail_price = @prices.values.map{ |prices| prices[:retail_price] }.sum
  end

  private
    def initialize line_item_group

      @line_item_group = line_item_group

      @prices = {}
      @by_payment = {}
      @single_transports = []
      @unified_transport = []

    end


    def self.prices_of business_transaction
      {
        retail_price: retail_price_of(business_transaction),
        net_price: net_price_of(business_transaction),
        quantity: business_transaction.quantity_bought
      }
    end

     # article price * quanity
    def self.retail_price_of business_transaction
      business_transaction.article_price * business_transaction.quantity_bought
    end

    # net article price * quantity
    def self.net_price_of business_transaction
      ( business_transaction.article_price / (( 100 + business_transaction.article_vat ) / 100.0 )) * business_transaction.quantity_bought
    end

    def prepare_payment_for business_transaction
      payment = business_transaction.selected_payment.to_sym
      @by_payment[payment] ||= []
      @by_payment[payment].push business_transaction
    end

    def prepare_transport_for business_transaction
      if business_transaction.is_in_unified_transport?
        @unified_transport.push business_transaction
      else
        @single_transports.push business_transaction
      end
    end
end
