class AddLegalEntityToUsers < ActiveRecord::Migration
  def change
    add_column :users, :legal_entity, :boolean
  end
end
