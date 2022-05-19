class RenameTemplateName < ActiveRecord::Migration[4.2]
  def change
    rename_column :articles, :template_name, :article_template_name
  end
end
