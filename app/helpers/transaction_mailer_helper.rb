# encoding: utf-8

module TransactionMailerHelper

  def transaction_mail_greeting transaction, role
    case role
      when :buyer
        t('transaction.notifications.greeting') + (transaction.buyer_forename || transaction.forename) + ','
      when :seller
        t('transaction.notifications.greeting') + transaction.article_seller_forename + ','
    end
  end

  def fairnopoly_email_footer
    "#{ t('common.fn_legal_footer.intro')}\n" +
    "******************************************************************\n" +
    "#{t('common.fn_legal_footer.footer_contact')}\n\n" +
    "#{t('common.fn_legal_footer.registered')}\n" +
    "#{t('common.fn_legal_footer.board')}\n" +
    "#{t('common.fn_legal_footer.supervisory_board')}\n\n" +
    "#{t('common.brand')}\n" +
    "#{t('common.claim')}\n\n" +
    "#{t('common.fn_legal_footer.facebook')}\n" +
    "#{t('common.fn_legal_footer.buy_shares')}\n" +
    "******************************************************************"
  end

  def show_contact_info_seller seller
    string = ""
    if seller.is_a? LegalEntity
      if seller.company_name
        string += "#{seller.company_name}\n"
      end
      string += "#{seller.forename} #{seller.surname}\n"
    else
      string += "#{seller.title}\n"
      string += "#{seller.forename} #{seller.surname}\n"
    end
    string += "#{seller.street}\n"
    string += "#{seller.zip} #{seller.city}\n"
    string += "#{seller.country}\n\n"
    string += "#{seller.email}"
    string
  end

  def show_buyer_address transaction
    "#{transaction.forename} #{transaction.surname}\n" +
    "#{transaction.street}\n" +
    "#{transaction.zip} " + "#{transaction.city}\n" +
    "#{transaction.country}"
  end

  def order_details transaction
    string = ""
    string += "#{transaction.article_title}\n"
    if transaction.article.custom_seller_identifier
      string += "#{ t('transaction.notifications.seller.custom_seller_identifier')}" + "#{transaction.article.custom_seller_identifier}\n"
    end
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
    vat = transaction.article.vat
    vat_price = transaction.article.vat_price * transaction.quantity_bought
    price_without_vat = transaction.article.price_without_vat * transaction.quantity_bought
    total_price = transaction.article_transport_price( transaction.selected_transport, transaction.quantity_bought ) + ( transaction.article_price * transaction.quantity_bought )
    total_price_cash_on_delivery = transaction.article_transport_price( transaction.selected_transport, transaction.quantity_bought ) + ( transaction.article_price * transaction.quantity_bought ) + ( transaction.article_payment_cash_on_delivery_price * transaction.quantity_bought )

    string = ""
    string += "#{ t('transaction.edit.quantity_bought') }" + "#{transaction.quantity_bought}\n"
    string += "#{ t('transaction.edit.preliminary_price') }" + "#{humanized_money_with_symbol(transaction.article_price)}\n"
    string += "#{ t('transaction.edit.sales_price') }" + "#{humanized_money_with_symbol(transaction.article_price * transaction.quantity_bought)}\n"

    if transaction.seller.is_a?(LegalEntity)
      string += "#{ t('transaction.edit.net') }" + "#{ price_without_vat }\n"
      string += "#{ t('transaction.edit.vat', percent: vat) }" + "#{ vat_price }\n"
    end

    if role == :buyer
      string += "#{ t('transaction.notifications.buyer.fair_percent')}" + "#{humanized_money_with_symbol(transaction.article.calculated_fair * transaction.quantity_bought)}\n"
    end

    string += "----------------------------------------------\n"
    string += "#{ t('transaction.edit.shipping_and_handling') }" + "#{humanized_money_with_symbol(transaction.article_transport_price(transaction.selected_transport, transaction.quantity_bought))}\n"

    if role == :buyer && transaction.selected_payment == 'cash_on_delivery'
      string += "#{ t('transaction.edit.cash_on_delivery') }" + "#{humanized_money_with_symbol(transaction.article_payment_cash_on_delivery_price * transaction.quantity_bought)}\n"
    end

    string += "----------------------------------------------\n"

    if transaction.selected_payment == 'cash_on_delivery'
      string += "#{ t('transaction.edit.total_price')}" + "#{humanized_money_with_symbol( total_price_cash_on_delivery )}"
    else
      string += "#{ t('transaction.edit.total_price')}" + "#{humanized_money_with_symbol( total_price )}"
    end
    string
  end

  def payment_method_info transaction, role
    string = ""
    case transaction.selected_payment
      when 'cash_on_delivery'
        "#{ t('transaction.notifications.buyer.cash_on_delivery') }"
      when 'bank_transfer'
        string += "#{ t('transaction.notifications.buyer.bank_transfer') }\n\n"
        if role == :buyer
          string += "#{ t('transaction.notifications.buyer.please_pay') }\n"
          string += "https://www.fairnopoly.de/transactions/#{transaction.id}\n"
          string
        end
      when 'paypal'
        "#{ t('transaction.notifications.buyer.paypal') }"
      when 'invoice'
        "#{ t('transaction.notifications.buyer.invoice') }"
      when 'cash'
        "#{ t('transaction.notifications.buyer.cash') }"
    end
  end

  def fees_and_donations transaction
    calc_fee = transaction.article.calculated_fee * transaction.quantity_bought
    calc_fair = transaction.article.calculated_fair * transaction.quantity_bought
    calc_total = calc_fee + calc_fair
    vat_value = 19

    "#{ t('transaction.notifications.seller.fees') }" + "#{ humanized_money_with_symbol( calc_fee ) }\n" +
    "#{ t('transaction.notifications.seller.donations') }" + "#{ humanized_money_with_symbol( calc_fair ) }\n" +
    "-------------------------------\n" +
    "#{ t('transaction.edit.total_price') }" + "#{humanized_money_with_symbol( calc_total ) }" + "*\n" +
    "#{ t('transaction.edit.net') }" + "#{ humanized_money_with_symbol( net( calc_total)) }" + "#{ t('transaction.edit.vat', percent: vat_value) }" + "#{ humanized_money_with_symbol( vat(calc_total)) }"
  end

  def net price
    price / 1.19
  end

  def vat price
    price - price / 1.19
  end

  def buyer_message transaction
    unless transaction.message == nil
      transaction.message
    end
  end

  # wird erstmal nicht mehr verwendet
  #
  # def seller_bank_account seller
  #   "#{ t('transaction.notifications.seller.bank_account_owner') }: #{ seller.bank_account_owner }\n" +
  #   "#{ t('transaction.notifications.seller.bank_account_number') }: #{ seller.bank_account_number }\n" +
  #   "#{ t('transaction.notifications.seller.bank_code') }: #{ seller.bank_code }\n" +
  #   "#{ t('transaction.notifications.seller.bank_name') }: #{ seller.bank_name }"
  # end
end