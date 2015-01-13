class AfterBuyWorker
  include Sidekiq::Worker

  sidekiq_options queue: :after_buy,
                  retry: 10,
                  backtrace: true

  def perform cart_id
    cart = Cart.find cart_id

    CartMailerWorker.perform_async cart.id

    cart.line_item_groups.each do |lig|
      if lig.business_transactions.select{ |bt| bt.selected_payment == 'voucher' }.any?
        voucher = lig.voucher_payment.voucher_value

        lig.business_transactions.each do |bt|
          voucher -= bt.article_price

          unless voucher > 0
            send_to_fastbill(bt)
          end
        end
      else
        lig.business_transactions.each do |bt|
          send_to_fastbill(bt)
        end
      end
    end
  end

  private

    def send_to_fastbill(bt)
      if bt.article_price > 0
        FastbillWorker.perform_in 5.seconds, bt.id
      end
    end
end
