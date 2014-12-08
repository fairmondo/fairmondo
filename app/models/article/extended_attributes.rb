#
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
module Article::ExtendedAttributes
  extend ActiveSupport::Concern

  included do
    TRANSPORT_TYPES = [
      :type1, :type2, :pickup
    ]
    PAYMENT_TYPES = [
      :bank_transfer, :cash, :paypal, :cash_on_delivery, :invoice, :voucher
    ]

    # Action attribute: c/create/u/update/d/delete - for export and csv upload
    # keep_images attribute: see edit_as_new
    attr_accessor :action, :keep_images, :save_as_template, :tos_accepted,
                  :changing_state
    attr_writer :article_search_form
                # find a way to remove this! arcane won't like it

    # Auto Sanitize

    auto_sanitize :content, method: 'tiny_mce'
    auto_sanitize :title
    auto_sanitize :transport_type1_provider, :transport_type2_provider,
                  :transport_details
    auto_sanitize :transport_time, remove_all_spaces: true
    auto_sanitize :payment_details

    # Enumerize

    enumerize :condition, in: [:new, :old], predicates:  true
    enumerize :condition_extra, in: [
      :as_good_as_new, :as_good_as_warranted, :used_very_good, :used_good,
      :used_satisfying, :broken
    ] # refs #225
    enumerize :basic_price_amount, in: [
      :kilogram, :gram, :liter, :milliliter, :cubicmeter, :meter,
      :squaremeter, :portion
    ]

    # Monetize

    monetize :price_cents
    monetize :basic_price_cents
    monetize :transport_type2_price_cents, numericality: {
      greater_than_or_equal_to: 0, less_than_or_equal_to: 50000
    }, allow_nil: true
    monetize :transport_type1_price_cents, numericality: {
      greater_than_or_equal_to: 0, less_than_or_equal_to: 50000
    }, allow_nil: true
    monetize :payment_cash_on_delivery_price_cents, numericality: {
      greater_than_or_equal_to: 0, less_than_or_equal_to: 50000
    }, allow_nil: true


  end


  def transport_details_for type
    case type
    when :type1
      [self.transport_type1_price, self.transport_type1_number]
    when :type2
      [self.transport_type2_price, self.transport_type2_number]
    else
      [Money.new(0),0]
    end
  end

  def transport_provider transport
    case transport
    when 'pickup'
      I18n.t('enumerize.business_transaction.selected_transport.pickup')
    when 'type1'
      self.transport_type1_provider
    when 'type2'
      self.transport_type2_provider
    end
  end

  # Returns an array with all selected transport types.
  # Default transport will be the first element.
  #
  # @api public
  # @return [Array] An array with selected transport types.
  def selectable_transports
    selectable "transport"
  end

  # Returns an array with all selected payment types.
  # Default payment will be the first element.
  #
  # @api public
  # @return [Array] An array with selected payment types.
  def selectable_payments
    selectable "payment"
  end

  private


    # DRY method for selectable_transports and selectable_payments
    #
    # @api private
    # @return [Array] An array with selected attribute types
    def selectable attribute
      # Get all selected attributes
      output = []
      eval("#{attribute.upcase}_TYPES").each do |e|
        output << e.to_s if self.send "#{attribute}_#{e}"
      end
      output
    end
end
