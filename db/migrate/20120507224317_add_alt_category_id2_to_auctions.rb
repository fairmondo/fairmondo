class AddAltCategoryId2ToAuctions < ActiveRecord::Migration
  def change
    add_column :auctions, :alt_category_id_2, :integer

  end
end
