class PaymentsController < ApplicationController
  skip_before_filter :authenticate_user!, only: :ipn_notification
  protect_from_forgery except: :ipn_notification
  respond_to :html, except: :ipn_notification

  # create happens on buy. this is to initialize the payment with paypal
  def create
    @payment = Payment.new line_item_group_id: params[:line_item_group_id], type: Payment.parse_type(params[:type])
    authorize @payment
    if @payment.execute
      redirect_to PaypalAPI.checkout_url @payment.pay_key
    else
      redirect_to :back, flash: { error: I18n.t('paypal_api.controller_error', email: @payment.line_item_group_seller_paypal_account).html_safe }
    end
  end

  def show
    @payment = Payment.find(params[:id])
    authorize @payment
    redirect_to PaypalAPI.checkout_url @payment.pay_key
  end

  def ipn_notification
    ipn = PaypalAdaptive::IpnNotification.new
    ipn.send_back(request.raw_post)

    if ipn.verified?
      payment = Payment.find_by(pay_key: params['txn_id'])

      if payment
        payment.last_ipn = params.to_json
        if params[:payment_status] == 'Completed' && params[:receiver_email] == payment.line_item_group_buyer_email
          payment.success
        else
          payment.line_item_group.payment_error
        end
        payment.save
      end
    end

    render nothing: true
  end
end
