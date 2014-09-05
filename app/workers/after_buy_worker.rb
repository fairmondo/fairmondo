class AfterBuyWorker
  include Sidekiq::Worker

  sidekiq_options queue: :after_buy,
                  retry: 10,
                  backtrace: true

  def perform cart_id
    cart = Cart.find cart_id

    CartMailerWorker.perform_async cart.id

    cart.line_item_groups.each do |lig|
      lig.business_transactions.each do |bt|
        if bt.article_price > 0
          FastbillWorker.perform_in 5.seconds, bt.id
        end
      end
    end
  end
end
