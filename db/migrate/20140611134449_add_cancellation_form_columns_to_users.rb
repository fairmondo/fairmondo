class AddCancellationFormColumnsToUsers < ActiveRecord::Migration
  def change
    add_attachment :users, :cancellation_form
  end
end
