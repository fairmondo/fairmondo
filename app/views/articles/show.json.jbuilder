json.(@article,:id,:slug,:title,:price_cents,:quantity_available)
json.partial! 'articles/show/legal_entity', article: @article
json.partial! 'articles/show/tags', article: @article
json.partial! 'articles/show/donation', article: @article
json.categories resource.categories.each do |leaf|
  json.name leaf.name
  json.ancestors leaf.ancestors.map(&:name)
end
if @article.title_image
  json.title_image do
    json.thumb_url asset_url(@article.title_image.image.url :thumb)
    json.original_url asset_url(@article.title_image.image.url :original)
  end
end
if show_fair_percent_for? @article
  json.fair_percent_html t('article.show.donate_html')
end

json.thumbnails @article.thumbnails do |thumbnail|
  json.thumb_url asset_url(thumbnail.image.url :thumb)
  json.original_url asset_url(thumbnail.image.url :original)
end
json.seller do
  json.type @article.seller.type.underscore
  if @article.seller.is_a?(LegalEntity) && @article.seller.ngo
    json.type_name  t('users.legal_status.show.ngo')
  elsif @article.seller.is_a? LegalEntity
    json.type_name  t('users.legal_status.show.legal_entity')
  else
    json.type_name  t('users.legal_status.show.private_user')
  end
  json.ngo @article.seller.ngo
  json.name @article.seller.name
  json.vacationing @article.seller.vacationing?
  json.image_url @article.user.image_url(:profile)
  json.html_url user_url(@article.seller)
  json.ratings do
    json.url user_ratings_url(@article.seller)
    json.count @article.seller.ratings.count
    json.positive_percent @article.seller.percentage_of_positive_ratings
    json.neutral_percent @article.seller.percentage_of_neutral_ratings
    json.negative_percent @article.seller.percentage_of_negative_ratings
  end
  json.terms @article.seller.terms
  json.cancellation @article.seller.cancellation
end
json.content @article.content
json.payment_html render(partial: '/articles/show/payment', formats: [:html])
json.transport_html render(partial: '/articles/show/transport', formats: [:html])
json.commendation_html render(partial: '/articles/show/commendation', formats: [:html], locals: {commendation_link: url_for(controller: 'contents', action: 'show', id: 'faq', anchor: 'f1', only_path: false)})
json.html_url article_url(@article)
