class AddFieldsForFastbillToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :billed_for_fair, :boolean, default: false
    add_column :transactions, :billed_for_fee, :boolean, default: false
    add_column :transactions, :billed_for_discount, :boolean, default: false
  end
end
