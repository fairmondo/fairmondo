class AddStateToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :state, :string
  end
end
