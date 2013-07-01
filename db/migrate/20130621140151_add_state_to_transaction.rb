class AddStateToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :state, :string

    add_index :transactions, :buyer_id
  end
end
