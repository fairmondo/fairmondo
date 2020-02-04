class AddReferralToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :referral, :string, :default => ""
  end
end
