# encoding: utf-8

module TransactionMailerHelper

  def transaction_mail_greeting transaction, role
    case role
      when :buyer
        t('transaction.notifications.greeting') + ' ' + transaction.buyer_forename + ','
      when :seller
        t('transaction.notifications.greeting') + ' ' + transaction.article_seller_forename + ','
    end
  end

  def fairnopoly_email_footer
    "#{ t('common.fn_legal_footer.intro')}"
    "**************************************************************\n" +
    "Fairnopoly eG\n" +
    "Glogauerstr. 21\n" +
    "10999 Berlin\n\n" +
    "#{t('common.fn_legal_footer.registered')}\n" +
    "#{t('common.fn_legal_footer.board')}\n" +
    "#{t('common.fn_legal_footer.ceo')}\n" +
    "#{t('common.fn_legal_footer.supervisory_board')}\n\n" +
    "#{t('common.brand')}\n" +
    "#{t('common.claim')}\n" +
    "**************************************************************"
  end

  def show_contact_info_seller seller
    "#{seller.fullname}\n" +
    "#{seller.street}\n" +
    "#{seller.zip} " + "#{seller.city}\n\n" +
    "#{seller.email}"
  end

  def show_buyer_address transaction
    "#{transaction.forename} #{transaction.surname}\n" +
    "#{transaction.street}\n" +
    "#{transaction.zip} " + "#{transaction.city}\n\n" +
    "#{transaction.buyer_email}"
  end

  def order_details transaction
    string = ""
    string += "#{transaction.article_title}\n"
    string += "https://www.fairnopoly.de" + "#{article_path(transaction.article)}\n"
    string += "#{ t('transaction.edit.quantity_bought') }" + "#{transaction.quantity_bought.to_s}\n"
    case transaction.selected_payment
      when 'bank_transfer'
        string += "#{ t('transaction.edit.payment_type') }" + "#{ t('transaction.notifications.buyer.bank_transfer') }\n"
      when 'paypal'
        string += "#{ t('transaction.edit.payment_type') }" + "#{ t('transaction.notifications.buyer.paypal') }\n"
      when 'cash'
        string += "#{ t('transaction.edit.payment_type') }" + "#{ t('transaction.notifications.buyer.cash') }\n"
      when 'cash_on_delivery'
        string += "#{ t('transaction.edit.payment_type') }" + "#{ t('transaction.notifications.buyer.cash_on_delivery') }\n"
      when 'invoice'
        string += "#{ t('transaction.edit.payment_type') }" + "#{ t('transaction.notifications.buyer.invoice') }\n"
    end

    case transaction.selected_transport
      when 'pickup'
        string += "#{ t('transaction.edit.transport_type') }" + "#{t('transaction.notifications.transport.pickup')}\n"
      when 'type1'
        string += "#{ t('transaction.edit.transport_type') }" + "#{transaction.article_transport_type1_provider}\n"
      when 'type2'
        string += "#{ t('transaction.edit.transport_type') }" + "#{transaction.article_transport_type2_provider}\n"
    end
    string
  end

  def article_payment_info transaction, role
    string = ""
    string += "#{ t('transaction.edit.quantity_bought') }" + "#{transaction.quantity_bought}\n"
    string += "#{ t('transaction.edit.preliminary_price') }" + "#{humanized_money_with_symbol(transaction.article_price)}\n"
    string += "#{ t('transaction.edit.sales_price') }" + "#{humanized_money_with_symbol(transaction.article_price * transaction.quantity_bought)}\n"
    if role == :buyer
      string += "#{ t('transaction.notifications.buyer.fair_percent')}" + "#{humanized_money_with_symbol(transaction.article.calculated_fair)}\n"
    end
    string += "----------------------------------------------\n"
    string += "#{ t('transaction.edit.shipping_and_handling') }" + "#{humanized_money_with_symbol(transaction.article_transport_price(transaction.selected_transport, transaction.quantity_bought))}\n"
    if role == :buyer && transaction.selected_payment == 'cash_on_delivery'
      string += "#{ t('transaction.edit.cash_on_delivery') }" + "#{humanized_money_with_symbol(transaction.article_payment_cash_on_delivery_price * transaction.quantity_bought)}\n"
    end
    string += "----------------------------------------------\n"
    string += "#{ t('transaction.edit.total_price')}" + "#{humanized_money_with_symbol(transaction.article_transport_price(transaction.selected_transport, transaction.quantity_bought) + transaction.article_price * transaction.quantity_bought + transaction.article_payment_cash_on_delivery_price * transaction.quantity_bought)}"
    string
  end

  def payment_method_info transaction, role
    string = ""
    case transaction.selected_payment
      when 'cash_on_delivery'
        "#{ t('transaction.notifications.buyer.cash_on_delivery') }"
      when 'bank_transfer'
        string += "#{ t('transaction.notifications.buyer.bank_transfer') }\n"
        if role == :buyer
          string += "#{ t('transaction.notifications.buyer.please_pay') }\n" +
          "#{ seller_bank_account transaction.article_seller }"
        end
      when 'paypal'
        "#{ t('transaction.notifications.buyer.paypal') }"
      when 'invoice'
        "#{ t('transaction.notifications.buyer.invoice') }"
      when 'cash'
        "#{ t('transaction.notifications.buyer.cash') }"
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
    unless transaction.message == nil
      transaction.message
    end
  end
end