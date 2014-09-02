class LineItemGroupPolicy < Struct.new(:user, :line_item_group)
  def show?
    # XOR!!!
    user.is?(line_item_group.buyer) || user.is?(line_item_group.seller)
  end
end
