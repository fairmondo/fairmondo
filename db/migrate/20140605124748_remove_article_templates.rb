class RemoveArticleTemplates < ActiveRecord::Migration[4.2]
  class ArticleTemplate < ApplicationRecord
    has_one :article
  end

  class Article < ApplicationRecord
    belongs_to :article_template
  end

  def up
    add_column :articles, :template_name, :string

    ArticleTemplate.all.each do |template|
      template.article.update_attribute(:template_name, template.name)
      template.article.update_column(:state, "template")
    end

    remove_column :articles, :article_template_id
    drop_table :article_templates
  end

  def down

  raise ActiveRecord::IrreversibleMigration
  end
end
