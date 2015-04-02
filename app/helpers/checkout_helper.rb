# encoding: utf-8
#
# == License:
# Fairmondo - Fairmondo is an open-source online marketplace.
# Copyright (C) 2013 Fairmondo eG
#
# This file is part of Fairmondo.
#
# Fairmondo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairmondo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairmondo.  If not, see <http://www.gnu.org/licenses/>.
#
module CheckoutHelper

  def unified_transport_label_for group, price
    I18n.t('cart.texts.unified_transport', provider: group.seller.unified_transport_provider, price: money(price))
  end

  def checkout_options_for_payment selectables
    selectables.map{ |payment| [ I18n.t("enumerize.business_transaction.selected_payment.#{payment.to_s}"),payment] }
  end

  def checkout_options_for_single_transport line_item, preview
    transports = []
    # pickup should be last in list, that's why we assign a large value for compariso reasons
    preview[line_item].sort_by { |k, v| k == 'pickup' ? 1000000 : v.cents }.each do |transport, cost|
      provider = line_item.article.transport_provider transport
      transports.push ["#{ provider } (+#{ money(cost) })", transport]
    end
    transports
  end

  def unified_transport_first a,b
    a_value = a.article.unified_transport
    b_value = b.article.unified_transport
    if a_value == b_value
      0
    elsif a_value
      -1
    else
      1
    end
  end

  def terms_and_cancellation_label_for user
    terms_link = checkbox_link_helper I18n.t('cart.texts.terms'), profile_user_path(user, print: 'terms', format: :pdf)
    cancellation_link = checkbox_link_helper I18n.t('cart.texts.cancellation'), profile_user_path(user, print: 'cancellation', format: :pdf)
    I18n.t('cart.texts.terms_and_cancellation_label', terms: terms_link, cancellation: cancellation_link).html_safe
  end


  def line_item_group_title group
    t('cart.texts.line_item_group_by', seller: link_to(group.seller_nickname, user_path(group.seller))).html_safe
  end

  def visual_checkout_steps step, cart
    render 'carts/checkout/visual_steps', step: step, cart: cart
  end

  def visual_checkout_step step, active, checked, link=nil
    step_title = I18n.t("cart.steps.#{step.to_s}")
    content_tag :span, class: "visual_checkout_step #{active ? 'active' : ''}" do
      concat(content_tag(:i,'', class: (checked ? 'fa fa-check-square-o' : 'fa fa-square-o')))
      concat(' ')
      concat(link ? link_to(step_title, link) : step_title)
    end
  end

  # Show valid range of shipping times for courier_service
  #
  def courier_time_for line_item
    seller = line_item.article_seller
  end

end
