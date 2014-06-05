class RemoveArticleTemplates < ActiveRecord::Migration
  class ArticleTemplate < ActiveRecord::Base
    has_one :article
  end

  class Article < ActiveRecord::Base
    belongs_to :article_template
  end

  def up
    add_column :articles, :template_name, :string

    ArticleTemplate.all.each do |template|
      template.article.update_attribute(:template_name, template.name)
    end

    remove_column :articles, :article_template_id
    drop_table :article_templates
  end

  def down

  raise ActiveRecord::IrreversibleMigration
  end
end
