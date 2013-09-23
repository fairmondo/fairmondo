
# For rails-settings-cached
begin
  active_articles = Article.where(:state => :active)
  if active_articles
    last_article = active_articles.last
  end
rescue
  last_article = nil
  last_user = nil
ensure

  Settings.defaults[:pioneer_article_id] = last_article ? last_article.id : nil
  #TODO: make some better logic!
  Settings.defaults[:pioneer_article2_id] = last_article ? last_article.id : nil
  Settings.defaults[:dream_team_article_id] = last_article ? last_article.id : nil
  Settings.defaults[:dream_team_article2_id] = last_article ? last_article.id : nil
end
