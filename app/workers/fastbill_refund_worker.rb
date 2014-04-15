class FastbillRefundWorker
  include Sidekiq::Worker

  sidekiq_options queue: :fastbill,
                  retry: 20,
                  backtrace: true
  def perform transaction_id, fee_type
    transaction = Transaction.find(transaction_id)
    # Start the fastbill chain, to create invoices and add items to invoice
    FastbillAPI.fastbill_refund( transaction, fee_type.to_sym )
  end
end
