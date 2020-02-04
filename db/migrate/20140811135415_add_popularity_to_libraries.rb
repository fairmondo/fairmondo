class AddPopularityToLibraries < ActiveRecord::Migration[4.2]
  def change
    add_column :libraries, :popularity, :float, default: 0.0
  end
end
