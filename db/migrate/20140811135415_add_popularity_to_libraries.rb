class AddPopularityToLibraries < ActiveRecord::Migration
  def change
    add_column :libraries, :popularity, :float, default: 0.0
  end
end
