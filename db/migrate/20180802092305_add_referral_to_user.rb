class AddReferralToUser < ActiveRecord::Migration
  def change
    add_column :users, :referral, :string, :default => ""
  end
end
