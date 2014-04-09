# Helper for transaction views
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
module TransactionHelper

  # Return a basic display of the transport provider if one exists
  #
  # @param type [String] Transport type
  # @return [String, nil] Display HTML if there is something to display

  # def resource *transaction
  #   resource ||= transaction
  # end

  def display_price_list_item transpay, type
    if resource.send("article_selectable_#{transpay}s".to_sym).include?(type)
      output =
        '<li>'.html_safe +
          t("transaction.edit.#{type}")
      output +=
          ( resource.article.send("#{transpay}_#{type}_provider".to_sym) + ' ' ) if transpay == :transport
      output +=
          humanized_money_with_symbol(resource.article.send("#{transpay}_#{type}_price".to_sym))
      if transpay == :transport && ( resource.is_a? MultipleFixedPriceTransaction )
          output +=
            t("transaction.edit.per_transport_number", number: resource.article.send("transport_#{type}_number".to_sym))
      else
        output +=
          t("transaction.edit.per_transport")
      end
      output +=
        '</li>'.html_safe
    end
  end

  def display_preliminary_price
    output = t('transaction.edit.preliminary_price')
    if resource.article_seller.is_a?(LegalEntity) && resource.article_vat && resource.article_vat > 0
      output += t 'transaction.edit.including_vat', percent: resource.article_vat
    end
    output += ': '
    output += humanized_money_with_symbol resource.article_price
  end

  def display_selected_payment selected_payment
    tablerow(
      t('transaction.edit.payment_type'),
      t("enumerize.transaction.selected_payment.#{selected_payment}")
    )
  end

  def display_selected_transport selected_transport
    tablerow(
      t('transaction.edit.transport_type'),
      t("enumerize.transaction.selected_transport.#{selected_transport}")
    )
  end

  def display_transport_provider_for type
    if provider = resource.article_transport_provider(type)
      tablerow(
        t('transaction.edit.transport_provider'),
        provider
      )
    end
  end

  def display_optional_warning selected_transport, selected_payment
    if selected_transport == 'pickup' && selected_payment != 'cash' && resource.selected?('payment', 'cash')
      '<p><small class="SmallText RedText">'.html_safe +
        t('transaction.errors.no_pickup_cash_combination') +
      '</small></p>'.html_safe
    end
  end

  def display_article_link article
    tablerow(
      t('transaction.edit.article_link'), (link_to article.title, article)
    )
  end

  def display_quantity_bought quantity
    tablerow(
      t('transaction.edit.quantity_bought'),
      quantity.to_s
    )
  end

  def display_price_per_unit
    tablerow(
      t('transaction.edit.price_per_unit'),
      humanized_money_with_symbol(resource.article_price)
    )
  end

  def display_sales_price quantity = 1
    tablerow(
      t('transaction.edit.sales_price'),
      humanized_money_with_symbol(resource.article_price * quantity)
    )
  end

  # Return a display for the net price
  #
  # @return [String] Display HTML
  def display_net_price quantity
    tablerow(
      t('transaction.edit.net'),
      humanized_money_with_symbol(resource.article_price_without_vat quantity)
    )
  end

  # Return a display for the amount of money that goes towards taxes
  #
  # @return [String] Display HTML
  def display_vat_price quantity
    if resource.article_vat && resource.article_vat > 0
      tablerow(
        t('transaction.edit.vat', percent: resource.article_vat),
        humanized_money_with_symbol(resource.article_vat_price quantity)
      )
    end
  end

  # Return a basic display of the basic price for the current view's resource
  # if one exists.
  #
  # @return [String, nil] Display HTML if there is something to display
  def display_basic_price
    price = resource.article_basic_price
    if price && price > 0
      tablerow(
        t('transaction.edit.basic_price'),
        (
          humanized_money_with_symbol(price) + ' ' +
          t('common.text.glue.per') +
          t('enumerize.article.basic_price_amount.' + resource.article_basic_price_amount)
        )
      )
    end
  end


  def display_number_of_shipments selected_transport, quantity
    if ['type1', 'type2'].include? selected_transport
      tablerow(
        t('transaction.edit.number_of_shipments'),
        resource.article_number_of_shipments(selected_transport, quantity).to_s
      )
    end
  end

  def display_transport_price selected_transport, quantity = 1
    output_data = humanized_money_with_symbol(resource.article_transport_price(selected_transport, quantity))
    if selected_transport == 'type1'
      output_data += " (#{resource.article_transport_type1_provider})"
    elsif selected_transport == 'type2'
      output_data += " (#{resource.article_transport_type2_provider})"
    end

    tablerow(
      t('transaction.edit.shipping_and_handling'),
      output_data
    )
  end

  # Return a basic display of the cash on delivery price for the current view's
  # resource if one exists.
  #
  # @return [String, nil] Display HTML if there is something to display
  def display_cash_on_delivery_price selected_transport, selected_payment, quantity = 1
    if selected_payment == 'cash_on_delivery'
      tablerow(
        t('transaction.edit.payment_cash_on_delivery_price'),
        humanized_money_with_symbol(resource.article_cash_on_delivery_price(selected_transport, selected_payment, quantity))
      )
    end
  end


  def display_total_price selected_transport, selected_payment, quantity
    '<strong>'.html_safe +
    t('transaction.edit.total_price') +
    '</strong> '.html_safe +
    humanized_money_with_symbol(
      resource.article_total_price(selected_transport, selected_payment, quantity)
    )
  end

  def back_link quantity_bought, selected_transport, selected_payment, forename, surname, street, address_suffix, city, zip, country
    link_to t('common.actions.back'),
      edit_transaction_path(@transaction,
        transaction: {
          quantity_bought: quantity_bought,
          selected_transport: selected_transport,
          selected_payment: selected_payment,
          forename: forename,
          surname: surname,
          street: street,
          address_suffix: address_suffix,
          city: city,
          zip: zip,
          country: country
        }
      ),
      class: 'Button Button--gray'
  end

  private
    def tablerow content_header, content_data
      '<tr><th>'.html_safe +
        content_header +
      '</th><td>'.html_safe +
        content_data +
      '</th></tr>'.html_safe
    end
end
