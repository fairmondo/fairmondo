class AddCancellationFormColumnsToUsers < ActiveRecord::Migration[4.2]
  def change
    add_attachment :users, :cancellation_form
  end
end
