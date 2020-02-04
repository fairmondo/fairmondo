class AddVacationingToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :vacationing, :boolean, default: false
  end
end
