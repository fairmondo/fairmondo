# For rails-settings-cached
begin
  active_articles = Article.where(:state => :active)
  if active_articles
    last_article = active_articles.last
  end
rescue
  last_article = nil
ensure
  Settings.defaults[:featured_article_id] = last_article ? last_article.id : nil
end
