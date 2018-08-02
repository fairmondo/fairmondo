class AddReferralToUser < ActiveRecord::Migration
  def change
    add_column :users, :referral, :text, :default => ""
  end
end
