class FastbillRefundWorker
  include Sidekiq::Worker

  sidekiq_options queue: :fastbill,
                  retry: 20,
                  backtrace: true

  def perform id
    BusinessTransaction.transaction do
      bt = BusinessTransaction.lock.find(id)

      [:fair, :fee].each do |type|
        if bt.send("billed_for_#{ type }?")
          fastbill = FastbillAPI.new bt
          fastbill.send("fastbill_refund_#{ type }")
        end
      end
    end
  end

end
