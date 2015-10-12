#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module Article::ExtendedAttributes
  extend ActiveSupport::Concern

  included do
    TRANSPORT_TYPES = [
      :type1, :type2, :pickup, :bike_courier
    ]
    PAYMENT_TYPES = [
      :bank_transfer, :cash, :paypal, :cash_on_delivery, :invoice, :voucher
    ]

    # Action attribute: c/create/u/update/d/delete - for export and csv upload
    attr_accessor :action, :save_as_template, :tos_accepted,
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
    when :bike_courier
      [self.transport_bike_courier_price, self.transport_bike_courier_number]
    else
      [Money.new(0), 0]
    end
  end

  def transport_provider transport
    case transport
    when 'pickup'
      I18n.t('enumerize.business_transaction.selected_transport.pickup')
    when 'bike_courier'
      COURIER['name']
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
    selectable 'transport'
  end

  # Returns an array with all selected payment types.
  # Default payment will be the first element.
  #
  # @api public
  # @return [Array] An array with selected payment types.
  def selectable_payments
    selectable 'payment'
  end

  # Returns price for transport_bike_courier
  #
  # @api public
  # @return Money
  def transport_bike_courier_price
    if transport_bike_courier
      Money.new(COURIER['price'])
    end
  end

  # Returns price without vat
  #
  # @api public
  # @return Money
  def price_wo_vat
    case vat
    when 7
      price / 1.07
    when 19
      price / 1.19
    else
      price
    end
  end

  private

  # DRY method for selectable_transports and selectable_payments
  #
  # @api private
  # @return [Array] An array with selected attribute types
  def selectable attribute
    # Get all selected attributes
    output = []
    instance_eval("#{attribute.upcase}_TYPES").each do |e|
      output << e.to_s if self.send "#{attribute}_#{e}"
    end
    output
  end
end
