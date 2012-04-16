class CreateAuctions < ActiveRecord::Migration
  def change
    create_table :auctions do |t|
      t.string :title
      t.string :content
      t.string :imagePath

      t.timestamps
    end
  end
end
