class CartMailerWorker
  include Sidekiq::Worker

  sidekiq_options queue: :cart_mails,
                  retry: 10,
                  backtrace: true

  def perform cart_id
    Cart.transaction do
      cart = Cart.lock.find cart_id

      # send email to buyer
      unless cart.purchase_emails_sent
        CartMailer.buyer_email(cart).deliver
        cart.update_columns(purchase_emails_sent: true, purchase_emails_sent_at: Time.now)
      end

      cart.line_item_groups.each do |lig|
        unless lig.purchase_emails_sent
          # send email to seller
          CartMailer.seller_email(lig).deliver
          lig.update_columns(purchase_emails_sent: true, purchase_emails_sent_at: Time.now)
        end

        #lig.business_transactions.select{ |bt| bt.bike_courier_selected? }.each do |bt|
        #  # send email to courier
        #  CartMailer.courier_notification(bt).deliver
        #  bt.update_columns(courier_emails_sent: true, courier_emails_sent_at: Time.now)
        #end
      end
    end
  end
end
