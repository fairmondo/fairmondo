class AddImageProcessingToImage < ActiveRecord::Migration
   def self.up
      add_column :images, :image_processing, :boolean
    end

    def self.down
      remove_column :images, :image_processing
    end
end
