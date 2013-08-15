class ChangeMessageToTextInTransaction < ActiveRecord::Migration
  def up
    change_column :transactions, :message, :text
  end

  def down
    change_column :transactions, :message, :string
  end
end
