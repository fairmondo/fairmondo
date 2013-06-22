class AddLegalEntityFormToUser < ActiveRecord::Migration
  def change
    add_column :users, :legal_entity_form, :string
  end
end
