class TransactionMailerWorker
  include Sidekiq::Worker

  sidekiq_options queue: :transaction_mails,
                  retry: 5,
                  backtrace: true,
                  failures: true

  def perform transaction_id, type

    transaction = Transaction.find transaction_id
    raise Exception.new("Transaction #{transaction_id} not sold when trying to send transaction emails!") unless transaction.sold?
    type = case type.to_sym
    when :seller
      TransactionMailer.seller_notification(transaction).deliver
    when :buyer
      TransactionMailer.buyer_notification(transaction).deliver
    end

  end
end