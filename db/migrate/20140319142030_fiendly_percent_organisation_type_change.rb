class FiendlyPercentOrganisationTypeChange < ActiveRecord::Migration
  def up
    add_column :articles, :friendly_percent_organisation_id, :integer, :limit => 8
    Article.unscoped.where("friendly_percent_organisation IS NOT NULL").each do |article|
      begin
        article.update_column(:friendly_percent_organisation_id, article.friendly_percent_organisation.to_i)
      rescue
      end
    end
    remove_column :articles, :friendly_percent_organisation
  end

  def down
    # Please Dont
    raise ActiveRecord::IrreversibleMigration
  end
end
