class FastbillWorker
  include Sidekiq::Worker

  sidekiq_options queue: :fastbill,
                  retry: 20, # this means approx 6 days
                  backtrace: true,
                  failures: true
  def perform transaction_id
    transaction = Transaction.find(transaction_id)
    # Start the fastbill chain, to create invoices and add items to invoice
    FastbillAPI.fastbill_chain( transaction )
  end
end
