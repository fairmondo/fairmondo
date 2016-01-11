#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module PaypalAdaptive
  class Request
    def pay(data)
      PaypalAdaptive::Response.new('responseEnvelope' => {'ack' => 'Success'}, 'paymentExecStatus' => '+', 'payKey' => 'foobar')
    end
  end
end
