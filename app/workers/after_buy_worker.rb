#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class AfterBuyWorker
  include Sidekiq::Worker

  sidekiq_options queue: :after_buy,
                  retry: 10,
                  backtrace: true

  def perform cart_id
    cart = Cart.find cart_id

    CartMailerWorker.perform_async cart.id

    cart.line_item_groups.map(&:business_transactions).flatten.each do |bt|
      unless bt.seller.is_a?(PrivateUser) || (bt.voucher_selected? || bt.article_price <= 0)
        FastbillWorker.perform_in 5.seconds, bt.id
      end
    end

    cart.articles.each do |article|
      Indexer.index_article article
    end
  end
end
