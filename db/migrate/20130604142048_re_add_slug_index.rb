class ReAddSlugIndex < ActiveRecord::Migration
  class Article < ActiveRecord::Base
  end

  def up
    Article.reset_column_information
    doubled_articles = Article.find(:all, :group => [:slug], :having => "count(*) > 1" )
    doubled_articles.each do |article|
      while Article.where(:slug => article.slug).size != 0 do
         article.slug = "_" + article.slug
       end

      article.save!
    end
    add_index :articles, :slug, unique: true unless index_exists? :articles, :slug, unique: true
  end

  def down
    #not really needed
  end
end
