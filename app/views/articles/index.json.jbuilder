json.articles @articles do |article|
  json.(article, :title, :state,
      :id, :price_cents,
      :vat, :basic_price_cents,
      :basic_price_amount, :condition,
      :fair, :ecologic, :small_and_precious,
      :currency, :user_id, :slug,
      :borrowable, :swappable, :friendly_percent,
      :friendly_percent_organisation_id)
  json.title_image_url article.title_image_url_thumb
end
