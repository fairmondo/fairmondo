#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class CartAbacus
  attr_reader :cart, :group_totals, :line_item_totals, :total,
              :belboon_tracking_relevant_value

  def initialize cart
    @cart = cart
    @group_totals = {}
    @line_item_totals = {}
    calculate_total
    calculate_belboon_value if cart.user
  end

  private

  def calculate_total
    @cart.line_item_groups.each do |group|
      calculate_group group
    end
    @total = Money.new(@group_totals.values.sum)
  end

  def calculate_group group
    prices = group.line_items.map { |line_item| calculate_line_item line_item }

    group_total = Money.new(prices.sum)
    @group_totals[group] = group_total
    group_total
  end

  def calculate_line_item line_item
    line_item_total = line_item.requested_quantity * line_item.article_price
    @line_item_totals[line_item] = line_item_total
    line_item_total
  end

  # Belboon Stuff
  #
  def calculate_belboon_value
    line_items = @cart.line_items.select { |line_item| line_item.qualifies_for_belboon? }
    values = line_items.map { |line_item| calculate_belboon_line_item(line_item) if line_item.qualifies_for_belboon? }
    @belboon_tracking_relevant_value = Money.new(values.sum)
  end

  def calculate_belboon_line_item(line_item)
    line_item.requested_quantity * line_item.article_price_wo_vat
  end
end
