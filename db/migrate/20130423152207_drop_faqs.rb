class DropFaqs < ActiveRecord::Migration
  def up
    drop_table :faqs
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
