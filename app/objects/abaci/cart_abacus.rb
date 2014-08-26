class CartAbacus
  attr_reader :cart, :group_totals, :line_item_totals, :total

  def initialize cart
    @cart = cart
    @group_totals = {}
    @line_item_totals = {}
    calculate_total
  end

  private

    def calculate_total
      @cart.line_item_groups.each do |group|
        calculate_group group
      end
      @total = Money.new(@group_totals.values.sum)
    end

    def calculate_group group
      prices = group.line_items.map{|line_item| calculate_line_item line_item }

      group_total = Money.new(prices.sum)
      @group_totals[group] = group_total
      group_total
    end

    def calculate_line_item line_item
      line_item_total =  line_item.requested_quantity * line_item.article_price
      @line_item_totals[line_item] = line_item_total
      line_item_total
    end

end