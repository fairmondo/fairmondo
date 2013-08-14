class AddQuarterlyFeeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :quarterly_fee, :boolean, :default => false
  end
end
