class FastbillWorker
  include Sidekiq::Worker

  sidekiq_options queue: :fastbill,
                  retry: 20, # this means approx 6 days
                  backtrace: true
  def perform business_transaction_id
    business_transaction = BusinessTransaction.find(business_transaction_id)
    # Start the fastbill chain, to create invoices and add items to invoice
    FastbillAPI.fastbill_chain( business_transaction )
  end
end
