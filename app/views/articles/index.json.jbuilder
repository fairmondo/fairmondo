json.articles @articles do |article|
  json.id article.id
  json.slug article.slug
  json.title_image_url asset_url(article.title_image_url_thumb)
  json.html_url article_url(article)
  json.title article.title
  json.price_cents(article.price.is_a?(Money) ? article.price_cents : article.price)
  json.seller_legal_entity article.belongs_to_legal_entity?
  if article.belongs_to_legal_entity?
    json.vat article.vat
    json.basic_price_cents article.basic_price_cents
    json.basic_price_amount article.basic_price_amount
  end
  json.tags do
    json.condition article.condition
    json.fair article.fair
    json.ecologic article.ecologic
    json.small_and_precious article.small_and_precious
    json.borrowable article.borrowable
    json.swappable article.swappable
  end

  json.donation do
    if article.friendly_percent_organisation &&  article.friendly_percent
      json.percent article.friendly_percent
      json.organization do
        json.name article.friendly_percent_organisation_nickname
        json.id article.friendly_percent_organisation_id
        json.html_url user_url(article.friendly_percent_organisation)
      end
    else
      json.nil!
    end
  end

end
