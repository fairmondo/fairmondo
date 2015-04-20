class FastbillRefundWorker
  include Sidekiq::Worker

  sidekiq_options queue: :fastbill,
                  retry: 20,
                  backtrace: true

  def perform id
    BusinessTransaction.transaction do
      bt = BusinessTransaction.lock.find(id)
      fastbill = FastbillAPI.new bt

      [:fair, :fee].each do |type|
        fastbill.send("fastbill_refund_#{ type }")
      end
    end
  end
end
