class PaypalController < ApplicationController
  skip_before_filter :authenticate_user!, only: :ipn_notification
  protect_from_forgery except: :ipn_notification

  def ipn_notification
    ipn = PaypalAdaptive::IpnNotification.new
    ipn.send_back(request.raw_post)

    if ipn.verified?
      payment = Payment.find_by(pay_key: params['txn_id'])

      if payment
        payment.last_ipn = params.to_json
        if params[:payment_status] == 'Completed' && params[:receiver_email] == payment.line_item_group_buyer_email
          payment.line_item_group.confirm_payment
        else
          payment.line_item_group.payment_error
        end
        payment.save
      end
    end

    render nothing: true
  end
end
