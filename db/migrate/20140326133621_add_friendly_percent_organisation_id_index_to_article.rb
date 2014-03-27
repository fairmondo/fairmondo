class AddFriendlyPercentOrganisationIdIndexToArticle < ActiveRecord::Migration
  def change
    add_index :articles , :friendly_percent_organisation_id
  end
end
