module TransactionMailerHelper
	def display_total_price transaction, selected_transport, selected_payment, quantity
    ('<strong>' + t('transaction.edit.total_price') + '</strong> ' +
      humanized_money_with_symbol(
        transaction.article_total_price(selected_transport, selected_payment, quantity)
      )
    ).html_safe
  end


end