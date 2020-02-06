#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

def abacus_for bt_traits, attributes = {}, lig_traits = []
  @line_item_group = create :line_item_group, :with_business_transactions, *lig_traits, traits: bt_traits, articles_attributes: attributes
  @abacus = Abacus.new @line_item_group
end

def article_attributes_for prices, transport_prices, transport_numbers
  attributes = []
  prices.each_with_index do |price, index|
    attributes << { price: price,
                    transport_type1_price: transport_prices[index],
                    transport_type2_price: transport_prices[index],
                    transport_type1_number: transport_numbers[index],
                    transport_type2_number: transport_numbers[index]
                  }
  end
  attributes
end

class AbacusTest < ActiveSupport::TestCase
  let(:abacus) {}

  it 'calculates a total price and a proper net price with pickup and cash that is the retail price of the articles' do
    abacus_for([[:pickup, :cash]], [{ price: Money.new(200), vat: 7 }])
    @abacus.business_transaction_listing.prices.values.first[:net_price].must_equal Money.new(187)
    @abacus.total.must_equal @line_item_group.business_transactions.first.article.price * @line_item_group.business_transactions.first.quantity_bought
  end

  it 'calculates a total price, transport prices and payment totals for articles with various payments and transports' do
    prices = [Money.new(500), Money.new(1000), Money.new(5000)]
    transport_prices = [Money.new(500), Money.new(200), Money.new(200)]
    transport_numbers = [5, 1, 5]
    traits = [[:paypal, :transport_type1, :bought_five], [:paypal, :transport_type2], [:invoice, :transport_type1, :bought_ten]]
    attributes = article_attributes_for prices, transport_prices, transport_numbers
    abacus_for(traits, attributes)

    single_transport_totals = [(prices[0] * 5 + transport_prices[0]), (prices[1] + transport_prices[1]), (prices[2] * 10 + transport_prices[2] * 2)]
    # transports

    @abacus.transport_listing.single_transports.size.must_equal 3
    @abacus.transport_listing.single_transports.map { |_bt, transport| transport[:shipments] }.sort.must_equal [1, 1, 2]
    @abacus.transport_listing.single_transports.map { |_bt, transport| transport[:total] }.sort.must_equal single_transport_totals.sort
    assert_nil @abacus.transport_listing.unified_transport

    # payments
    @abacus.payment_listing.payments[:paypal][:transport_total].must_equal transport_prices[0..1].sum
    @abacus.payment_listing.payments[:invoice][:transport_total].must_equal(transport_prices[2] * 2)
    assert_nil @abacus.payment_listing.payments[:paypal][:cash_on_delivery_total]
    assert_nil @abacus.payment_listing.payments[:invoice][:cash_on_delivery_total]
    @abacus.payment_listing.payments.size.must_equal 2
    @abacus.payment_listing.payments[:paypal][:total].must_equal(transport_prices[0..1].sum + prices[0] * 5 + prices[1])
    @abacus.payment_listing.payments[:invoice][:total].must_equal((transport_prices[2] * 2) + prices[2] * 10)

    # totals
    @abacus.total.must_equal @abacus.payment_listing.payments[:paypal][:total] +  @abacus.payment_listing.payments[:invoice][:total]
  end

  it 'calculates a total price, transport prices and payment totals for unified transports' do
    prices = [Money.new(5000), Money.new(10000), Money.new(500)]
    transport_prices = [Money.new(500), Money.new(2000), Money.new(200)]
    transport_numbers = [1, 1, 1]
    traits = [[:paypal, :bought_five], [:paypal, :bought_five], [:paypal, :bought_ten]]
    attributes = article_attributes_for prices, transport_prices, transport_numbers
    abacus_for(traits, attributes, :with_unified_transport)

    shipments = 20.fdiv(@line_item_group.unified_transport_maximum_articles).ceil
    transport_price = @line_item_group.unified_transport_price * shipments

    # transports
    @abacus.transport_listing.single_transports.size.must_equal 0
    @abacus.transport_listing.unified_transport[:shipments].must_equal shipments
    @abacus.transport_listing.unified_transport[:transport_price].must_equal transport_price
    @abacus.transport_listing.unified_transport[:provider].must_equal @line_item_group.unified_transport_provider
    @abacus.transport_listing.total_transport.must_equal transport_price

    # payments
    assert_nil @abacus.payment_listing.payments[:paypal][:cash_on_delivery_total]
    @abacus.payment_listing.payments[:paypal][:transport_total] = transport_price
    @abacus.payment_listing.payments[:paypal][:total].must_equal(5 * prices[0] + 5 * prices[1] + 10 * prices[2] + transport_price)
    @abacus.payment_listing.payments.size.must_equal 1

    # total
    @abacus.total.must_equal @abacus.payment_listing.payments[:paypal][:total]
  end

  it 'calculates a total price, transport prices and payment totals for unified transports and 2 single transports with cash_on_delivery' do
    prices = [Money.new(50000), Money.new(1000), Money.new(5000), Money.new(54321)]
    transport_prices = [Money.new(5000), Money.new(2000), Money.new(2000), Money.new(11)]
    transport_numbers = [1, 1, 1, 5]
    traits = [[:bank_transfer, :bought_five], [:bank_transfer, :bought_five], [:cash_on_delivery, :bought_ten, :transport_type1], [:cash_on_delivery, :bought_ten, :transport_type2]]
    attributes = article_attributes_for prices, transport_prices, transport_numbers
    attributes.last(2).each { |attr| attr[:unified_transport] = false } # set the last 2 articles to single transport
    abacus_for(traits, attributes, :with_unified_transport)

    unified_shipments = 10.fdiv(@line_item_group.unified_transport_maximum_articles).ceil
    unified_transport_price = @line_item_group.unified_transport_price * unified_shipments

    cash_on_delivery_prices = @abacus.transport_listing.single_transports.map { |bt, hash| bt.article.payment_cash_on_delivery_price * hash[:shipments] }.sort
    single_transport_prices = [(10 * transport_prices[2]), (2 * transport_prices[3])].sort

    # transports
    @abacus.transport_listing.single_transports.size.must_equal 2
    @abacus.transport_listing.single_transports.values.map { |h| h[:transport_price] }.sort.must_equal single_transport_prices
    @abacus.transport_listing.single_transports.values.map { |h| h[:cash_on_delivery] }.sort.must_equal cash_on_delivery_prices

    @abacus.transport_listing.unified_transport[:shipments].must_equal unified_shipments
    @abacus.transport_listing.unified_transport[:transport_price].must_equal unified_transport_price
    @abacus.transport_listing.unified_transport[:provider].must_equal @line_item_group.unified_transport_provider
    @abacus.transport_listing.unified_transport[:total].must_equal 5 * prices[0] + 5 * prices[1] + unified_transport_price
    @abacus.transport_listing.total_transport.must_equal unified_transport_price + single_transport_prices.sum

    # payments
    @abacus.payment_listing.payments.size.must_equal 2
    @abacus.payment_listing.payments[:cash_on_delivery][:cash_on_delivery_total].must_equal cash_on_delivery_prices.sum
    @abacus.payment_listing.payments[:cash_on_delivery][:transport_total].must_equal single_transport_prices.sum
    @abacus.payment_listing.payments[:cash_on_delivery][:total].must_equal(10 * prices[2] + 10 * prices[3] + cash_on_delivery_prices.sum + single_transport_prices.sum)
    @abacus.payment_listing.payments[:bank_transfer][:transport_total].must_equal unified_transport_price
    @abacus.payment_listing.payments[:bank_transfer][:total].must_equal 5 * prices[0] + 5 * prices[1] + unified_transport_price
    @abacus.total.must_equal @abacus.payment_listing.payments[:bank_transfer][:total] + @abacus.payment_listing.payments[:cash_on_delivery][:total]
  end

  it 'calculates a total price, transport prices and payment totals for unified transports and single transports with unified payment' do
    prices = [Money.new(5060), Money.new(1006), Money.new(34006)]
    transport_prices = [Money.new(5600), Money.new(200), Money.new(2010)]
    transport_numbers = [1, 1, 1]
    traits = [[:bank_transfer, :transport_type1], [:bank_transfer, :bought_ten, :transport_type1], [:bank_transfer, :bought_five, :pickup]]
    attributes = article_attributes_for prices, transport_prices, transport_numbers
    attributes.last[:unified_transport] = false # set the last articleto single transport
    abacus_for(traits, attributes, :with_unified_transport)

    unified_shipments = 11.fdiv(@line_item_group.unified_transport_maximum_articles).ceil
    unified_transport_price = @line_item_group.unified_transport_price * unified_shipments
    total = prices[0] + 10 * prices[1] + prices[2] * 5 + unified_transport_price

    # transports
    @abacus.transport_listing.single_transports.size.must_equal 1
    @abacus.transport_listing.single_transports.values.first[:transport_price].must_equal Money.new(0)
    @abacus.transport_listing.single_transports.values.first[:method].must_equal :pickup
    @abacus.transport_listing.single_transports.values.first[:shipments].must_equal 0
    @abacus.transport_listing.single_transports.values.first[:total].must_equal 5 * prices[2]

    @abacus.transport_listing.unified_transport[:shipments].must_equal unified_shipments
    @abacus.transport_listing.unified_transport[:transport_price].must_equal unified_transport_price
    @abacus.transport_listing.unified_transport[:provider].must_equal @line_item_group.unified_transport_provider
    @abacus.transport_listing.unified_transport[:method].must_equal :unified
    @abacus.transport_listing.unified_transport[:total].must_equal prices[0] + 10 * prices[1] + unified_transport_price

    # payments
    @abacus.payment_listing.payments.size.must_equal 1
    @abacus.payment_listing.payments[:bank_transfer][:transport_total].must_equal unified_transport_price
    @abacus.payment_listing.payments[:bank_transfer][:total].must_equal total
    @abacus.total.must_equal total
  end

  it 'calculates a total price, transport prices and payment totals for unified transports and 2 single transports with cash_on_delivery and a dontaion' do
    prices = [Money.new(5000), Money.new(6543), Money.new(1111), Money.new(54321)]
    transport_prices = [Money.new(5000), Money.new(2000), Money.new(2000), Money.new(11)]
    transport_numbers = [1, 1, 1, 5]
    traits = [[:bank_transfer, :bought_five], [:bank_transfer, :bought_five], [:cash_on_delivery, :bought_ten, :transport_type1], [:cash_on_delivery, :bought_ten, :transport_type2]]
    attributes = article_attributes_for prices, transport_prices, transport_numbers
    attributes.last(2).each { |attr| attr[:unified_transport] = false } # set the last 2 articles to single transport
    ngo = create :legal_entity, ngo: true
    attributes.each { |attr| attr[:friendly_percent] = 75 }
    attributes.each { |attr| attr[:friendly_percent_organisation] = ngo }
    abacus_for(traits, attributes, [:with_unified_transport, :with_free_transport_at_40])

    unified_shipments = 10.fdiv(@line_item_group.unified_transport_maximum_articles).ceil
    cash_on_delivery_prices = @abacus.transport_listing.single_transports.map { |bt, hash| bt.article.payment_cash_on_delivery_price * hash[:shipments] }.sort

    # transports
    @abacus.transport_listing.single_transports.size.must_equal 2
    @abacus.transport_listing.single_transports.values.map { |h| h[:transport_price] }.must_equal [Money.new(0), Money.new(0)]
    @abacus.transport_listing.single_transports.values.map { |h| h[:cash_on_delivery] }.sort.must_equal cash_on_delivery_prices

    @abacus.transport_listing.unified_transport[:shipments].must_equal unified_shipments
    @abacus.transport_listing.unified_transport[:transport_price].must_equal Money.new(0)
    @abacus.transport_listing.unified_transport[:provider].must_equal @line_item_group.unified_transport_provider
    @abacus.transport_listing.unified_transport[:total].must_equal 5 * prices[0] + 5 * prices[1]

    # payments
    @abacus.payment_listing.payments.size.must_equal 2
    @abacus.payment_listing.payments[:cash_on_delivery][:cash_on_delivery_total].must_equal cash_on_delivery_prices.sum
    @abacus.payment_listing.payments[:cash_on_delivery][:transport_total].must_equal Money.new(0)
    @abacus.payment_listing.payments[:cash_on_delivery][:total].must_equal(10 * prices[2] + 10 * prices[3] + cash_on_delivery_prices.sum)
    @abacus.payment_listing.payments[:bank_transfer][:transport_total].must_equal Money.new(0)
    @abacus.payment_listing.payments[:bank_transfer][:total].must_equal 5 * prices[0] + 5 * prices[1]
    @abacus.total.must_equal @abacus.payment_listing.payments[:bank_transfer][:total] + @abacus.payment_listing.payments[:cash_on_delivery][:total]

    # donations
    @abacus.donation_listing.donation_per_organisation[ngo].must_equal(Money.new(@line_item_group.business_transactions.map { |t| t.article.calculated_friendly_cents * t.quantity_bought }.sum))
  end
end
