#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class PaypalPayment < Payment
  extend STI

  def after_create_path
    PaypalAPI.checkout_url pay_key
  end

  # totally untested function that really should be part of abacus
  def total_tax
    total = Money.new(0)

    self.business_transactions.each do |bt|
      price = bt.article_price - (bt.article_price / (1.0 + bt.article_vat / 100.0))
      total += price * bt.quantity_bought
    end

    total
  end

  private

  # send paypal request on init
  def initialize_payment
    response = PaypalAPI.new.request_for(self)
    if response.success?
      self.pay_key = response['payKey']

      # second call to set_payment_options with pay_key and other data
      PaypalAPI.new.set_payment_options(self)

      true # continue
    else
      self.error = response.errors.to_json
      false # errored instead of initialized
    end
  end
end
