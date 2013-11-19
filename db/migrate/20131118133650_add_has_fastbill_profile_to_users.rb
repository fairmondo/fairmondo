class AddHasFastbillProfileToUsers < ActiveRecord::Migration
  def change
    add_column :users, :has_fastbill_profile, :boolean, default: false
  end
end
