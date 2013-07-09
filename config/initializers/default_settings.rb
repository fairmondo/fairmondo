# For rails-settings-cached
begin
  last_article = Article.last
rescue
  last_article = nil
ensure
  Settings.defaults[:featured_article_id] = last_article ? last_article.id : nil
end
