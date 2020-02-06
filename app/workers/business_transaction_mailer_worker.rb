#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class BusinessTransactionMailerWorker
  include Sidekiq::Worker

  sidekiq_options queue: :transaction_mails,
                  retry: 5,
                  backtrace: true

  def perform business_transaction_id, type
    business_transaction = BusinessTransaction.find business_transaction_id
    raise Exception.new("BusinessTransaction #{business_transaction_id} not sold when trying to send transaction emails!") unless business_transaction.sold?
    case type.to_sym
    when :seller
      BusinessTransactionMailer.seller_notification(business_transaction).deliver_later
    when :buyer
      BusinessTransactionMailer.buyer_notification(business_transaction).deliver_later
    end
  end
end
