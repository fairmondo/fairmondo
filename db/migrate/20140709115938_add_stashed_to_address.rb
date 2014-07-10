class AddStashedToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :stashed, :boolean, default: false
  end
end
