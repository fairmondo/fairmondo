class FastbillWorker
  include Sidekiq::Worker

  sidekiq_options queue: :fastbill,
                  retry: 20, # this means approx 6 days
                  backtrace: true

  def perform(id)
    BusinessTransaction.transaction do
      bt = BusinessTransaction.lock.find(id)
      # check if bt is qualified for discount
      Discount.discount_chain(bt) if bt.article_discount_id
      # Start the fastbill chain, to create invoices and add items to invoice
      api = FastbillAPI.new(bt)
      api.fastbill_chain
    end
  end
end
