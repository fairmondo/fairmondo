class AfterBuyWorker
  include Sidekiq::Worker

  sidekiq_options queue: :after_buy,
                  retry: 10,
                  backtrace: true

  def perform cart_id
    cart = Cart.find cart_id

    CartMailerWorker.perform_async cart.id

    cart.line_item_groups.each do |lig|
      voucher = lig.voucher_payment.voucher_value if lig.voucher_payment

      lig.business_transactions.each do |bt|

        unless (voucher && voucher >= 0 && bt.voucher_selected?) || bt.article_price <= 0
          FastbillWorker.perform_in 5.seconds, bt.id
        end

        voucher -= bt.article_price if voucher && bt.voucher_selected?
      end
    end

    cart.articles.each do |article|
      Indexer.index_article article
    end
  end

end
