class MakeTransactionModelReadyForBattle < ActiveRecord::Migration

  class BusinessTransaction < ActiveRecord::Base
    belongs_to :line_item_group
  end

  class LineItemGroup < ActiveRecord::Base
    has_many :business_transactions
  end

  def up
    add_column :articles, :quantity_available, :integer
    add_column :business_transactions, :line_item_group_id, :integer, limit: 8
    change_column :line_item_groups, :unified_transport, :boolean, default: false
    change_column :line_item_groups, :unified_payment, :boolean, default: false

    mfps = BusinessTransaction.where(type: 'MultipleFixedPriceTransaction')
    mfps.find_each do |mfp|
      mfp.article.update_column(:quantity_available, mfp.quantity_available)
      mfp.destroy
    end

    BusinessTransaction.where(type: 'PreviewTransaction').destroy_all

    BusinessTransaction.where(state: 'available').find_each do |t|
      t.destroy
    end
    BusinessTransaction.all.find_each do |t|
      lig = LineItemGroup.create(message: t.message, tos_accepted: t.tos_accepted, user_id: t.seller.id, created_at: t.created_at, updated_at: t.updated_at)
      t.line_item_group_id = lig.id
      t.save!
    end

    remove_column(:business_transactions,:quantity_available)
    remove_column(:business_transactions, :type)
    remove_column(:business_transactions, :expire) rescue nil
    remove_column(:business_transactions, :message)
    remove_column(:business_transactions, :tos_accepted)
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
