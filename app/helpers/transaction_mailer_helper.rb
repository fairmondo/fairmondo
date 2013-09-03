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
 		"Fairnopoly e.G\n" +
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
end