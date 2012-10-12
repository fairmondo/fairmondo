class AddCodeToFfps < ActiveRecord::Migration
  def change
    add_column :ffps, :code, :string
  end
end
