json.donation do
  if article.seller_ngo
    json.percent 100
    json.organization do
      json.name article.seller_nickname
      json.id article.seller
      json.html_url user_url(article.seller)
    end
  elsif show_friendly_percent_for? article
    json.percent article.friendly_percent
    json.organization do
      json.name article.friendly_percent_organisation_nickname
      json.id article.friendly_percent_organisation_id
      json.html_url user_url(article.friendly_percent_organisation_id)
    end
  else
    json.nil!
  end
end
