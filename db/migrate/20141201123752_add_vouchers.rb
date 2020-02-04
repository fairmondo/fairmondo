class AddVouchers < ActiveRecord::Migration[4.2]
  def change
    add_column :articles, :payment_voucher, :boolean, default: false
    add_column :users, :uses_vouchers, :boolean, default: false
  end
end
