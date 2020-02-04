class ChangeMessageToTextInTransaction < ActiveRecord::Migration[4.2]
  def up
    change_column :transactions, :message, :text
  end

  def down
    change_column :transactions, :message, :string
  end
end
