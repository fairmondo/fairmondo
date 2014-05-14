class FastbillRefundWorker
  include Sidekiq::Worker

  sidekiq_options queue: :fastbill,
                  retry: 20,
                  backtrace: true
  def perform business_transaction_id, fee_type
    business_transaction = BusinessTransaction.find(business_transaction_id)
    # Start the fastbill chain, to create invoices and add items to invoice
    FastbillAPI.fastbill_refund( business_transaction, fee_type.to_sym )
  end
end
