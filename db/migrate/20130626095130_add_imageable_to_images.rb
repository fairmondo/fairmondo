class AddImageableToImages < ActiveRecord::Migration
  def change
    add_column :images, :imageable_id, :integer
    add_column :images, :imageable_type, :string
    add_index :images, [:imageable_id, :imageable_type]

    drop_table :articles_images


    remove_column :users, :image_file_name
    remove_column :users, :image_content_type
    remove_column :users, :image_file_size
    remove_column :users, :image_updated_at
  end

  def down
    remove_column :images, :imageable_id
    remove_column :images, :imageable_type

    create_table :articles_images, :id => false do |t|
        t.references :image
        t.references :article
    end
    add_index :articles_images, [:image_id, :article_id]
    add_index :articles_images, [:article_id, :image_id]


    add_column :users, :image_file_name, :string
    add_column :users, :image_content_type, :string
    add_column :users, :image_file_size, :integer
    add_column :users, :image_updated_at, :datetime
  end
end
