#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class PaymentsController < ApplicationController
  PERMITTED_PARAMS = %i(type pay_key line_item_group_id).freeze

  before_action :setup_ipn, only: :ipn_notification
  skip_before_action :authenticate_user!, only: :ipn_notification
  protect_from_forgery except: :ipn_notification
  respond_to :html, except: :ipn_notification

  # create happens on buy. this is to initialize the payment with paypal
  def create
    params[:payment].merge!(line_item_group_id: params[:line_item_group_id])
    payment_attrs = params.require(:payment).permit(*PERMITTED_PARAMS)
    @payment = Payment.new payment_attrs
    authorize @payment
    if @payment.execute
      redirect_to_payment_path
    else
      redirect_back fallback_location: root_path, flash: { error: I18n.t("#{@payment.type}.controller_error", email: @payment.line_item_group_seller_paypal_account).html_safe }
    end
  end

  def show
    @payment = Payment.find(params[:id])
    authorize @payment
    redirect_to PaypalAPI.checkout_url @payment.pay_key
  end

  # receives instant payment notifications from paypal
  #
  def ipn_notification
    if @ipn.verified?
      handle_payment
    else
      raise StandardError, 'ipn could not be verified'
    end
    head :ok
  end

  def confirm_or_decline payment
    payment.last_ipn = params.to_json
    if params && params[:status].upcase == 'COMPLETED' # && params[:sender_email] == payment.line_item_group_buyer_email
      payment.confirm
      send_courier_notifications_for payment
    else
      payment.decline
    end
  end

  private

  def setup_ipn
    @ipn = PaypalAdaptive::IpnNotification.new
    @ipn.send_back(request.raw_post)
  end

  def redirect_to_payment_path
    redirect_path = @payment.after_create_path
    case redirect_path
    when :back
      redirect_back fallback_location: root_path
    else
      redirect_to redirect_path
    end
  end

  def handle_payment
    if payment = Payment.find_by(pay_key: params['pay_key'])
      confirm_or_decline payment
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  def send_courier_notifications_for payment
    # Only send email to courier service if bike_courier is the selected transport
    bts = payment.line_item_group.business_transactions.select { |bt| bt.bike_courier_selected? }
    bts.each do |bt|
      CartMailer.courier_notification(bt).deliver_later
    end
  end
end
