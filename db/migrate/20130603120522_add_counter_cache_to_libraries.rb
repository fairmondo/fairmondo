class AddCounterCacheToLibraries < ActiveRecord::Migration
  def change
    add_column :libraries, :library_elements_count, :integer, default: 0
  end
end
