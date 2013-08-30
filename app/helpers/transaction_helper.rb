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

  def transport_provider_for type
    if provider = resource.article_transport_provider(type)
      "<br><strong>#{t('transaction.edit.transport_provider')}</strong> #{provider}".html_safe
    end
  end


  def display_preliminary_price
    output = t('transaction.edit.preliminary_price')
    if resource.article_vat && resource.article_vat > 0
      output += t 'transaction.edit.including_vat', percent: resource.article_vat
    end
    output += ': '
    output += humanized_money_with_symbol resource.article_price_without_vat
  end

  def display_sales_price quantity = 1
    t('transaction.edit.sales_price') +
    humanized_money_with_symbol(resource.article_price_without_vat(quantity))
  end

  def display_total_price selected_transport, selected_payment, quantity
    ('<strong>' + t('transaction.edit.total_price') + '</strong> ' +
      humanized_money_with_symbol(
        resource.article_total_price(selected_transport, selected_payment, quantity)
      )
    ).html_safe
  end

  # Return a basic display of the cash on delivery price for the current view's
  # resource if one exists.
  #
  # @return [String, nil] Display HTML if there is something to display
  def display_cash_on_delivery_price selected_payment, quantity = 1
    if (price = resource.article_payment_cash_on_delivery_price) > 0 && selected_payment == 'cash_on_delivery'

      (t('transaction.edit.payment_cash_on_delivery_price') +
      ' ' + humanized_money_with_symbol(price * quantity))
    end
  end

  def display_transport_price selected_transport, quantity = 1
    output = "<strong>#{I18n.t 'transaction.edit.shipping_and_handling'}</strong> ".html_safe
    output += humanized_money_with_symbol(resource.article_transport_price(selected_transport, quantity))
    if selected_transport == 'type1'
      output += " (#{resource.article_transport_type1_provider})"
    elsif selected_transport == 'type2'
      output += " (#{resource.article_transport_type2_provider})"
    end
  end

  # Return a basic display of the pasic price for the current view's resource
  # if one exists.
  #
  # @return [String, nil] Display HTML if there is something to display
  def display_basic_price
    if (price = resource.article_basic_price) > 0
      "<br>#{t('transaction.edit.basic_price')} ".html_safe +
      "#{humanized_money_with_symbol(price)} " +
      t('common.text.glue.per') +
      t('enumerize.article.basic_price_amount.'+resource.article_basic_price_amount)
    end
  end

  # Return a display for the amount of money that goes towards taxes
  #
  # @return [String] Display HTML
  def display_vat_price quantity
    if resource.article_vat && resource.article_vat > 0
      output = '<br>'.html_safe
      output += I18n.t 'transaction.edit.vat', percent: resource.article_vat
      output += " "
      output += humanized_money_with_symbol resource.article_vat_price quantity
    end
  end

  # Return a display for the net price
  #
  # @return [String] Display HTML
  def display_net_price quantity
    output = '<br>'.html_safe
    output += I18n.t 'transaction.edit.net'
    output += " "
    output += humanized_money_with_symbol resource.article_price_without_vat quantity
  end
end
