class AddMessageToTransaction < ActiveRecord::Migration[4.2]
  def change
    add_column  :transactions, :message, :string, default: nil
  end
end
