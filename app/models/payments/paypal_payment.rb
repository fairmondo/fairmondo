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
