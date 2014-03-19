# encoding: utf-8

module TransactionMailerHelper
  # This Helper houses some methods that build all the different strings for the transaction
  # notifiction emails

  def transaction_mail_greeting transaction, role
    case role
      when :buyer
        t('transaction.notifications.greeting') + (transaction.buyer_forename || transaction.forename) + ','
      when :seller
        t('transaction.notifications.greeting') + transaction.article_seller_forename + ','
    end
  end

  def show_contact_info_seller seller
    string = ""
    string += t('transaction.notifications.seller.nickname')
    string += "#{seller.nickname}\n"
    string += "#{user_url seller}\n\n"
    if seller.is_a? LegalEntity
      if seller.company_name.present?
        string += t('transaction.notifications.seller.company_name')
        string += "#{seller.company_name}\n"
      end
      string += t('transaction.notifications.seller.contact_person')
      string += "#{seller.forename} #{seller.surname}\n"
    else
      string += "#{seller.title}\n" if seller.title
      string += "#{seller.forename} #{seller.surname}\n"
    end
    string += "#{seller.address_suffix}\n" if seller.address_suffix
    string += "#{seller.street}\n"
    string += "#{seller.zip} #{seller.city}\n"
    string += "#{seller.country}\n\n"
    string += "#{seller.email}"
    string
  end

  def show_buyer_address transaction
    string = ""
    string += "#{transaction.forename} #{transaction.surname}\n"
    string += "#{transaction.address_suffix}\n" if transaction.address_suffix
    string += "#{transaction.street}\n"
    string += "#{transaction.zip} #{transaction.city}\n"
    string += "#{transaction.country}"
    string
  end

  def order_details transaction, role = :buyer
    string = ""
    string += transaction.article_title + "\n"
    if transaction.article_custom_seller_identifier
      string += "#{ t('transaction.notifications.seller.custom_seller_identifier')}" + "#{transaction.article_custom_seller_identifier}\n"
    end
    string += article_url(transaction.article) + "\n"
    string += t('transaction.notifications.transaction_link')
    string += transaction_url(transaction) + "\n"
    if ['bank_transfer', 'paypal', 'cash', 'cash_on_delivery', 'invoice'].include? transaction.selected_payment
      string += t('transaction.edit.payment_type')
      string += t("transaction.notifications.buyer.#{transaction.selected_payment}") + "\n"
    end

    string += transport_details transaction

    string += t("transaction.notifications.#{role}.transaction_id_info", id: transaction.id)
    string
  end

  def article_payment_info transaction, role
    vat = transaction.article_vat
    vat_price = transaction.article.vat_price * transaction.quantity_bought
    price_without_vat = transaction.article.price_without_vat * transaction.quantity_bought
    total_price = transaction.article_transport_price( transaction.selected_transport, transaction.quantity_bought ) + ( transaction.article_price * transaction.quantity_bought )
    total_price_cash_on_delivery = transaction.article_transport_price( transaction.selected_transport, transaction.quantity_bought ) + ( transaction.article_price * transaction.quantity_bought ) + ( transaction.article_payment_cash_on_delivery_price * transaction.quantity_bought )

    string = ""
    string += "#{ t('transaction.edit.quantity_bought') }" + "#{transaction.quantity_bought}\n"
    string += "#{ t('transaction.edit.preliminary_price') }" + "#{humanized_money_with_symbol(transaction.article_price)}\n"
    string += "-------------------------------\n"
    string += "#{ t('transaction.edit.sales_price') }" + "#{humanized_money_with_symbol(transaction.article_price * transaction.quantity_bought)}\n"

    if transaction.seller.is_a?(LegalEntity)
      string += "#{ t('transaction.edit.net') }" + "#{ price_without_vat }\n"
      string += "#{ t('transaction.edit.vat', percent: vat) }" + "#{ vat_price }\n"
    end

    if role == :buyer && !transaction.article_seller_ngo
      if transaction.article.shows_fair_percent?
        string += "#{ t('transaction.notifications.buyer.fair_percent')}" + "#{humanized_money_with_symbol(transaction.article.calculated_fair * transaction.quantity_bought)}\n"
      end
      if transaction.article.has_friendly_percent?
        ngo = transaction.article.donated_ngo
        fp = transaction.article_friendly_percent
        amount = humanized_money_with_symbol(friendly_percent_with_quantity transaction)
        string += "#{ t('transaction.notifications.buyer.friendly_percent', ngo: ngo.nickname, percent: fp, amount: amount)}\n"
      end

    end

    string += "----------------------------------------------\n"
    string += "#{ t('transaction.edit.shipping_and_handling') }: " + "#{humanized_money_with_symbol(transaction.article_transport_price(transaction.selected_transport, transaction.quantity_bought))}\n"

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
    "#{ t('transaction.edit.net') }" + "#{ humanized_money_with_symbol( net( calc_total)) }\n" +
    "#{ t('transaction.edit.vat', percent: vat_value) }" + "#{ humanized_money_with_symbol( vat(calc_total)) }\n\n\n" +
    ( !transaction.article_seller_ngo ? "#{ t('transaction.notifications.seller.quarter_year_fees') }" : "" )

  end

  def net price
    price / 1.19
  end

  def vat price
    price - price / 1.19
  end

  private
    # gets called in order_details; in extra function to improve readability
    def transport_details transaction
      output = ''
      if ['pickup', 'type1', 'type2'].include? transaction.selected_transport
        output += t('transaction.edit.transport_type')

        output += case transaction.selected_transport
          when 'pickup'
            t('enumerize.transaction.selected_transport.pickup') + "\n"
          when 'type1'
            transaction.article_transport_type1_provider
          when 'type2'
            transaction.article_transport_type2_provider
        end

        unless transaction.selected_transport == 'pickup'
          output += t('transaction.notifications.general.shipments', count: transaction.article_number_of_shipments(transaction.selected_transport, transaction.quantity_bought)) + "\n"
        end

        output += "\n"
      end
      output
    end

  # wird erstmal nicht mehr verwendet
  #
   def show_bank_account_or_contact user
     if user.bank_account_exists?
      "#{ t('transaction.notifications.seller.bank_account_owner') } #{ user.bank_account_owner }\n" +
     "#{ t('transaction.notifications.seller.bank_account_number') } #{ user.bank_account_number }\n" +
     "#{ t('transaction.notifications.seller.bank_code') } #{ user.bank_code }\n" +
     "#{ t('transaction.notifications.seller.bank_name') } #{ user.bank_name }" +
     "#{ t('transaction.notifications.seller.iban') } #{ user.iban }" +
     "#{ t('transaction.notifications.seller.bic') } #{ user.bic }"
     else
      "#{ t('transaction.notifications.seller.no_bank_acount') } #{ user.email }"
     end
   end

   def friendly_percent_with_quantity transaction
      transaction.article.calculated_friendly * transaction.quantity_bought
   end

end
