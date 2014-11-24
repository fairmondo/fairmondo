json.articles @articles do |article|
  json.id article.id
  json.slug article.slug
  json.title_image_url asset_url(article.title_image_url_thumb)
  json.html_url article_url(article)
  json.title article.title
  json.price_cents(article.price.is_a?(Money) ? article.price_cents : article.price)
  json.partial! 'articles/show/legal_entity', article: article
  json.partial! 'articles/show/tags', article: article

  json.seller do
    json.nickname article.seller_nickname
    json.legal_entity article.belongs_to_legal_entity?
    json.html_url user_url(article.seller_id)
  end
  json.partial! 'articles/show/donation', article: article
end
