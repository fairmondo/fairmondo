class LineItemGroup < ActiveRecord::Base
  belongs_to :seller, class_name: 'User', foreign_key: 'user_id'
  belongs_to :cart
  has_many :line_items, dependent: :destroy

  def handle_transactions_individually?
    master_line_item_id == nil
  end

  def master_line_item
    self.line_items.find self.master_line_item_id
  end

end
