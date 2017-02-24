#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class CommonSenseValidator < ActiveModel::EachValidator
  # Check if selected payment method fits selected transport method
  #
  # @api public
  # @param record [Transaction] currently only supports transactions
  # @param attribute [String] currently only supports selected_payment
  # @param selected_payment [String] The payment type to check
  # @return [undefined]
  def validate_each(record, attribute, selected_payment)
    if record.is_a? BusinessTransaction
      common_sense_error = common_sense_check selected_payment, record.selected_transport
      record.errors[attribute] << common_sense_error if common_sense_error

    elsif record.is_a? LineItemGroup
      # happens on transactions individually if not unified
      if record.unified_payment
        record.business_transactions.each do |business_transaction|
          common_sense_error = common_sense_check selected_payment, business_transaction.selected_transport
          if common_sense_error
            record.errors[attribute] << common_sense_error
            return # do not add this error more than once
          end
        end
      end
    end
  end

  private

  def common_sense_check selected_payment, selected_transport
    if (selected_payment == 'cash_on_delivery' && selected_transport == 'pickup') || (selected_payment == 'cash' && selected_transport != 'pickup')
      I18n.t 'transaction.errors.combination_invalid',
             selected_payment: I18n.t("enumerize.business_transaction.selected_payment.#{selected_payment}")
    elsif (selected_payment != 'paypal' && selected_transport == 'bike_courier')
      I18n.t 'transaction.errors.bike_courier_requires_paypal'
    end
  end
end
