class AddMessageToTransaction < ActiveRecord::Migration
  def change
    add_column  :transactions, :message, :string, default: nil
  end
end
