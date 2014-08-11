require_relative '../test_helper'

def abacus_for bt_traits, attributes = {}, lig_traits = []
  @line_item_group = FactoryGirl.create :line_item_group, :with_business_transactions, *lig_traits , traits: bt_traits, articles_attributes: attributes
  @abacus = Abacus.new @line_item_group
end

def article_attributes_for prices, transport_prices, transport_numbers
  attributes = []
  prices.each_with_index do |price,index|
    attributes << { price: price,
                    transport_type1_price: transport_prices[index],
                    transport_type2_price: transport_prices[index],
                    transport_type1_number: transport_numbers[index],
                    transport_type2_number: transport_numbers[index],
                  }
  end
  attributes
end

describe 'Abacus' do
  let(:abacus) { }

  it 'calculates a total price and a proper net price with pickup and cash that is the retail price of the articles' do
    abacus_for([[:pickup,:cash]],[{price: Money.new(200), vat: 7}])
    @abacus.business_transaction_listing.prices.values.first[:net_price].must_equal Money.new(187)
    @abacus.total.must_equal @line_item_group.business_transactions.first.article.price * @line_item_group.business_transactions.first.quantity_bought
  end

  it 'calculates a total price, transport prices and payment totals for articles with various payments and transports' do
    prices = [ Money.new(500), Money.new(1000), Money.new(5000)]
    transport_prices = [Money.new(500), Money.new(200), Money.new(200)]
    transport_numbers = [5,1,5]
    traits = [[:paypal, :transport_type1, :bought_five], [:paypal, :transport_type2], [:invoice, :transport_type1, :bought_ten]]
    attributes = article_attributes_for prices, transport_prices, transport_numbers
    abacus_for(traits,attributes)

    # transport prices
    @abacus.payment_listing.payments[:paypal][:transport_total].must_equal transport_prices[0..1].sum
    @abacus.payment_listing.payments[:invoice][:transport_total].must_equal (transport_prices[2] * 2)
    @abacus.payment_listing.payments[:paypal][:cash_on_delivery_total].must_equal nil
    @abacus.payment_listing.payments[:invoice][:cash_on_delivery_total].must_equal nil
    @abacus.payment_listing.payments.size.must_equal 2

    #transports

    @abacus.transport_listing.single_transports.size.must_equal 3
    @abacus.transport_listing.single_transports.map{ |bt,transport| transport[:shipments] }.sort.must_equal [1,1,2]
    @abacus.transport_listing.unified_transport.must_equal nil

    # totals
    @abacus.payment_listing.payments[:paypal][:total].must_equal (transport_prices[0..1].sum + prices[0]*5+ prices[1])
    @abacus.payment_listing.payments[:invoice][:total].must_equal ((transport_prices[2] * 2) + prices[2]*10)
    @abacus.total.must_equal @abacus.payment_listing.payments[:paypal][:total] +  @abacus.payment_listing.payments[:invoice][:total]

  end

  it 'calculates a total price, transport prices and payment totals for unified transports' do
    prices = [ Money.new(5000), Money.new(10000), Money.new(500)]
    transport_prices = [Money.new(500), Money.new(2000), Money.new(200)]
    transport_numbers = [1,1,1]
    traits = [[:paypal, :bought_five], [:paypal, :bought_five], [:paypal, :bought_ten]]
    attributes = article_attributes_for prices, transport_prices, transport_numbers
    abacus_for(traits, attributes, :with_unified_transport)

    shipments = 20.fdiv(@line_item_group.unified_transport_maximum_articles).ceil
    transport_price = @line_item_group.unified_transport_price * shipments
    # transport prices
    @abacus.payment_listing.payments[:paypal][:cash_on_delivery_total].must_equal nil
    @abacus.payment_listing.payments[:paypal][:transport_total] = transport_price

    # transports
    @abacus.transport_listing.single_transports.size.must_equal 0
    @abacus.transport_listing.unified_transport[:shipments].must_equal shipments
    @abacus.transport_listing.unified_transport[:price].must_equal transport_price
    @abacus.transport_listing.unified_transport[:provider].must_equal @line_item_group.unified_transport_provider

    #totals
    @abacus.payment_listing.payments[:paypal][:total].must_equal 5 * prices[0] + 5 * prices[1] + 10 * prices[2] + transport_price
    @abacus.payment_listing.payments.size.must_equal 1
    @abacus.total.must_equal @abacus.payment_listing.payments[:paypal][:total]

  end

  it 'calculates a total price, transport prices and payment totals for unified transports and single transports with cash_on_delivery' do
    prices = [ Money.new(50000), Money.new(1000), Money.new(5000)]
    transport_prices = [Money.new(5000), Money.new(2000), Money.new(2000)]
    transport_numbers = [1,1,1]
    traits = [[:cash_on_delivery, :bought_five], [:bank_transfer, :bought_five], [:bank_transfer, :bought_ten, :transport_type1]]
    attributes = article_attributes_for prices, transport_prices, transport_numbers
    attributes.last[:unified_transport] = false # set the last articleto single transport
    abacus_for(traits, attributes, :with_unified_transport)

    unified_shipments = 10.fdiv(@line_item_group.unified_transport_maximum_articles).ceil
    unified_transport_price = @line_item_group.unified_transport_price * unified_shipments
    unified_cash_on_delivery_price = @line_item_group.unified_transport_cash_on_delivery_price * unified_shipments

    # transports
    @abacus.transport_listing.single_transports.size.must_equal 1
    @abacus.transport_listing.single_transports.first[:price].must_equal 10 * transport_prices[2]
    @abacus.transport_listing.unified_transport[:shipments].must_equal shipments
    @abacus.transport_listing.unified_transport[:price].must_equal transport_price
    @abacus.transport_listing.unified_transport[:provider].must_equal @line_item_group.unified_transport_provider
    @abacus.transport_listing.unified_transport[:cash_on_delivery].must_equal unified_cash_on_delivery_price

  end



end