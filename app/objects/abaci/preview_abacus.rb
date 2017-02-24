#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class PreviewAbacus
  attr_reader :transports, :unified_transport, :unified_transport_price,
              :number_of_shipments, :free_transport, :free_transport_at_price

  def initialize line_item_group
    @line_item_group = line_item_group
    check_free_transport
    @transports = {}
  end

  def self.calculate line_item_group
    abacus = PreviewAbacus.new line_item_group
    abacus.calculate_transport_prices
    abacus.calculate_unified_transport_price
    abacus
  end

  def calculate_transport_prices
    @line_item_group.line_items.each do |line_item|
      @transports[line_item] = transport_prices_for line_item
    end
  end

  def calculate_unified_transport_price
    unified_transport_items = @line_item_group.line_items.select { |line_item| line_item.article.unified_transport? }
    seller = @line_item_group.seller
    requested_articles = unified_transport_items.map(&:requested_quantity).sum
    @number_of_shipments = TransportAbacus.number_of_shipments requested_articles, seller.unified_transport_maximum_articles
    @unified_transport_price = seller.unified_transport_price
    @unified_transport = transport_price @unified_transport_price, number_of_shipments
  end

  private

  def check_free_transport
    total = calculate_total_retail_price
    seller = @line_item_group.seller
    @free_transport_at_price = seller.free_transport_at_price if seller.free_transport_available
    @free_transport = (free_transport_at_price && total >= free_transport_at_price)
  end

  def calculate_total_retail_price
    @line_item_group.line_items.map { |item| item.requested_quantity * item.article_price }.sum || Money.new(0)
  end

  def transport_prices_for line_item
    article = line_item.article
    transport_hash = article.selectable_transports.map do |transport|
      single_transport_price, transport_number = article.transport_details_for transport.to_sym
      number_of_shipments = TransportAbacus.number_of_shipments line_item.requested_quantity, transport_number
      [transport, transport_price(single_transport_price, number_of_shipments)]
    end

    transport_hash.to_h
  end

  def transport_price transport_price, number_of_shipments
    @free_transport ? Money.new(0) : (number_of_shipments * transport_price)
  end
end
