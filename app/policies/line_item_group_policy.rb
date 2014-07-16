class LineItemGroupPolicy < Struct.new(:user, :line_item_group)
  def show?
    # XOR!!!
    (line_item_group.buyer == user) ^ (line_item_group.seller == user)
  end
end
