if article.belongs_to_legal_entity?
  json.vat article.vat if article.vat != 0
  if show_basic_price_for? article
    json.basic_price_cents (article.basic_price.is_a?(Money) ? article.basic_price_cents : article.basic_price)
    json.basic_price_amount article.basic_price_amount
  end
end
