if @line_item.errors.any?
  json.error I18n.t('line_item.notices.error_quantity')
else
	json.cart_id @cart.id
  json.cart_url cart_url(@cart)
  json.line_item @line_item
end
