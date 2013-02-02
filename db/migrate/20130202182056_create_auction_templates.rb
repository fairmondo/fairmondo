class CreateAuctionTemplates < ActiveRecord::Migration
  def change
    create_table :auction_templates do |t|
      t.string :name
      t.integer :user_id

      t.timestamps
    end
    
    add_column :auctions, :auction_template_id, :integer
    
  end
end
