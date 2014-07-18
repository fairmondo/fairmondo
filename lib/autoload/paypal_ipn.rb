# Allow the metal piece to run in isolation
require(File.dirname(__FILE__) + "/../../config/environment") unless defined?(Rails)

class PaypalIpn
  def self.call(env)
    if env["PATH_INFO"] =~ /^\/paypal_ipn/
      request = Rack::Request.new(env)
      params = request.params

      ipn = PaypalAdaptive::IpnNotification.new
      ipn.send_back(env['rack.request.form_vars'])
      if ipn.verified?
        #mark transaction as completed in DB
        payment = Payment.where( pay_key: params['txn_id'] ).first
        if payment
          payment.last_ipn = params.to_json
          if payment_status == "Completed" && params['receiver_email'] == payment.transaction_article_seller_email
            payment.success
          else
            payment.error
          end
          payment.save
        end
        ##

        output = "Verified."
      else
        output = "Not Verified."
      end

      [200, {"Content-Type" => "text/html"}, [output]]
    else
      [404, {"Content-Type" => "text/html"}, ["Not Found"]]
    end
  end
end