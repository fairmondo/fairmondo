class AddVacationingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :vacationing, :boolean, default: false
  end
end
