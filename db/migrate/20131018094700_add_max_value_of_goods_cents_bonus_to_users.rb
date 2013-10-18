class AddMaxValueOfGoodsCentsBonusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :max_value_of_goods_cents_bonus, :integer, default: 0
  end
end
