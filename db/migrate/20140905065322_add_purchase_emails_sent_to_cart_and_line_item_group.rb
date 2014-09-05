class AddPurchaseEmailsSentToCartAndLineItemGroup < ActiveRecord::Migration
  class Cart < ActiveRecord::Base
  end

  class LineItemGroup < ActiveRecord::Base
  end

  def change
    add_column :carts, :purchase_emails_sent, :boolean, default: false
    add_column :carts, :purchase_emails_sent_at, :datetime, default: nil
    add_column :line_item_groups, :purchase_emails_sent, :boolean, default: false
    add_column :line_item_groups, :purchase_emails_sent_at, :datetime, default: nil
  end
end
