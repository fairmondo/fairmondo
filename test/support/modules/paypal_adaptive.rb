module PaypalAdaptive
  class Request
    def pay(data)
      PaypalAdaptive::Response.new('responseEnvelope' => {'ack' => 'Success'}, 'paymentExecStatus' => '+', 'payKey' => 'foobar')
    end
  end
end
