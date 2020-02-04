class AddFriendlyPercentOrganisationIdIndexToArticle < ActiveRecord::Migration[4.2]
  def change
    add_index :articles , :friendly_percent_organisation_id
  end
end
