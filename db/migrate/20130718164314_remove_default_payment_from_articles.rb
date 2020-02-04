class RemoveDefaultPaymentFromArticles < ActiveRecord::Migration[4.2]
  def up
    remove_column :articles, :default_payment
  end

  def down
    add_column :articles, :default_payment, :string
  end
end
