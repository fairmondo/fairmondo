class RenamePurposesToCheckboxes < ActiveRecord::Migration[4.2]
  def change
    rename_column :social_producer_questionnaires, :nonprofit_association_purposes, :nonprofit_association_checkboxes
    rename_column :social_producer_questionnaires, :social_businesses_muhammad_yunus_purposes, :social_businesses_muhammad_yunus_checkboxes
    rename_column :social_producer_questionnaires, :social_entrepreneur_purposes, :social_entrepreneur_checkboxes
  end

end
