# encoding: utf-8

module TransactionMailerHelper
	def mail_display_total_price transaction, selected_transport, selected_payment, quantity
    ('<strong>' + t('transaction.edit.total_price') + '</strong> ' +
      humanized_money_with_symbol(
        transaction.article_total_price(selected_transport, selected_payment, quantity)
      )
    ).html_safe
  end

 	def transaction_mail_greeting transaction, role
 		case role
 			when :buyer
 				t('transaction.notifications.greeting') + ' ' + @transaction.buyer.forename + ','
 			when :seller
				t('transaction.notifications.greeting') + ' ' + @transaction.article_seller.forename + ','
		end
 	end

 	def fairnopoly_email_footer
		"**************************************************************\n" +
 		"Fairnopoly eG\n" +
 		"Glogauerstr. 21\n" +
 		"10999 Berlin\n\n" +
 		"Registergericht: Amtsgericht Berlin-Charlottenburg, GnR 738 B\n" +
 		"Vorstand: Anna Kress, Bastian Neumann\n" +
 		"Vorstandsvorsitzender: Felix Weth\n" +
 		"Aufsichtsrat: Kim Stattaus, Anne Schollmeyer, Ernst Neumeister\n\n" +
 		"www.fairnopoly.de\n" +
 		"dreh' das Spiel um\n" +
 		"**************************************************************"
 	end

  def show_contact_info role
    "#{role.fullname}\n" +
    "#{role.street}\n" +
    "#{role.zip} " + "#{role.city}\n" +
    "#{role.email}"
  end

  def article_details transaction
    "#{transaction.article_title}\n" +
    "https://www.fairnopoly.de" + "#{article_path(transaction.article)}\n" +
    "Artikelanzahl: " + "#{transaction.quantity_bought.to_s}\n" +
    "Bezahlmethode: " + "#{transaction.selected_payment}\n" +
    "Versandmethode: " + "#{transaction.selected_transport}\n"
  end

  def article_payment_info transaction
    "#{ t('transaction.edit.quantity_bought') }" + "#{transaction.quantity_bought}\n" +
    "#{ t('transaction.edit.preliminary_price') }" + "#{humanized_money_with_symbol(transaction.article_price)}\n" +
    "#{ t('transaction.edit.sales_price') }" + "#{humanized_money_with_symbol(transaction.article_price * transaction.quantity_bought)}\n" +
    "Durch Deinen Kauf ermoeglichst Du eine Spende von: " + "#{humanized_money_with_symbol(transaction.article.calculated_fair)}\n" +
    "----------------------------------------------\n" +
    "Versandkosten: " + "#{humanized_money_with_symbol(transaction.article_transport_price(transaction.selected_transport, transaction.quantity_bought))}\n" +
    "----------------------------------------------\n" +
    "Gesamt: " + "#{humanized_money_with_symbol(transaction.article_transport_price(transaction.selected_transport) + transaction.article_price * transaction.quantity_bought)}"
  end

  def payment_method_info transaction
    case transaction.selected_payment
      when :cash_on_delivery
        "#{t('transaction.notifications.buyer.cash_on_delivery')}"
      when :bank_transfer
        "#{t('transaction.notifications.buyer.bank_transfer')}\n" +
        "#{seller_bank_account transaction.article_seller}"
      when :paypal
        "#{t('transaction.notifications.buyer.paypal')}"
    end
  end

  def seller_bank_account seller
    "#{ t('transaction.notifications.seller.bank_account_owner') }: #{ seller.bank_account_owner }\n" +
    "#{ t('transaction.notifications.seller.bank_account_number') }: #{ seller.bank_account_number }\n" +
    "#{ t('transaction.notifications.seller.bank_code') }: #{ seller.bank_code }\n" +
    "#{ t('transaction.notifications.seller.bank_name') }: #{ seller.bank_name }"
  end

  def fees_and_donations transaction
    "#{ t('transaction.notifications.seller.fees') }" + "#{ humanized_money_with_symbol( transaction.article.calculated_fee * transaction.quantity_bought ) }\n" +
    "#{ t('transaction.notifications.seller.donations') }" + "#{ humanized_money_with_symbol( transaction.article.calculated_fair * transaction.quantity_bought ) }"
  end

  def buyer_message transaction
    if transaction.message?
      transaction.message
    else
      ""
    end
  end

end