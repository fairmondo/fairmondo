#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class PaypalPayment < Payment
  extend STI

  def after_create_path
    PaypalAPI.checkout_url pay_key
  end

  private

  # send paypal request on init
  def initialize_payment
    response = PaypalAPI.new.request_for(self)
    if response.success?
      self.pay_key = response['payKey']
      true # continue
    else
      self.error = response.errors.to_json
      false # errored instead of initialized
    end
  end
end
