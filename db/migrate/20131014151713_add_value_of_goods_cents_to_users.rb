class AddValueOfGoodsCentsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :value_of_goods_cents, :integer, :default => 0
  end
end
