class RenameTemplateName < ActiveRecord::Migration
  def change
    rename_column :articles, :template_name, :article_template_name
  end
end
