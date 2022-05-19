class AddValueOfGoodsCentsToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :value_of_goods_cents, :integer, :default => 0
  end
end
