class ConvertArticleStateToStateMachine < ActiveRecord::Migration
  class Article < ActiveRecord::Base

  end

  def up
    add_column :articles, :state, :string
    Article.reset_column_information
    Article.all.each do |article|
      if article.active && article.locked
        article.state = "active"
      elsif !article.active && article.locked
        article.state = "locked"
      elsif !article.active && !article.locked
        article.state = "preview"
      end
      article.save
    end
    remove_column :articles, :locked

  end

  def down
    add_column :articles,:locked, :boolean
    Article.reset_column_information
    Article.all.each do |article|
      if article.state == "preview"
        article.locked = false
      else
        article.locked = true
      end
      article.save
    end
    remove_column :articles, :state
  end
end
