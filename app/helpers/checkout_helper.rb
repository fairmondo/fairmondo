# encoding: utf-8
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
module CheckoutHelper

  def unified_transport_label_for group
    I18n.t('checkout.labels.unified_transport', provider: group.seller.unified_transport_provider, transport_price: humanized_money_with_symbol(group.seller.unified_transport_price))
  end

  def unified_payment_options_for group
    group.unified_payments_selectable.map{ |payment| [I18n.t("enumerize.business_transaction.selected_payment.#{payment.to_s}"),payment] }
  end

  def line_item_group_frame(heading, options = {}, &block)
    render layout: "line_item_group_frame",
      locals: {
        heading: heading,
        frame_class: options[:frame_class] || ""
      }, &block
  end

  def line_item_group_title group
    safe_join([ t('cart.texts.line_item_group_by'), ' ' , link_to(group.seller_nickname, user_path(group.seller)) ])
  end

end