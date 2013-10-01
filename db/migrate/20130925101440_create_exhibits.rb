class CreateExhibits < ActiveRecord::Migration
  def up
    create_table :exhibits do |t|
      t.integer :article_id
      t.string :queue
      t.integer :related_article_id

      t.timestamps
    end
  end

  def down
    drop_table :exhibits
  end

end
