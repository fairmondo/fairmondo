class AddAltCategoryId1ToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :alt_category_id_1, :integer

  end
end
