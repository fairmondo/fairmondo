class AddTotalPurchaseDonationsCentsToUsers < ActiveRecord::Migration[4.2]
  def up
    add_column :users, :total_purchase_donations_cents, :integer, limit:   8,
                                                                  default: 0

    User.find_each do |user|
      total_purchase_donations = 0

      user.buyer_line_item_groups.find_each do |lig|
        lig.business_transactions.where(refunded_fair: false).find_each do |bt|
          total_purchase_donations += bt.total_fair_cents if bt.article.present?
        end # /business_transaction
      end # /line_item_group

      if total_purchase_donations > 0
        user.update_column :total_purchase_donations_cents,
                           total_purchase_donations
      end
    end # /user
  end

  def down
    remove_column :users, :total_purchase_donations_cents
  end
end
