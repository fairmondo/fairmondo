class RenameLegalEntityFormToCompanyName < ActiveRecord::Migration
  def up
    rename_column :users, :legal_entity_form, :company_name
  end

  def down
    rename_column :users, :company_name, :legal_entity_form
  end
end
