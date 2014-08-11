#
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
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
        record.line_items.map(&:business_transaction).each do |business_transaction|
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
    if (selected_payment == 'cash_on_delivery' && selected_transport == 'pickup') or (selected_payment == 'cash' && selected_transport != 'pickup')
        I18n.t 'transaction.errors.combination_invalid',
            selected_payment: I18n.t("enumerize.business_transaction.selected_payment.#{selected_payment}")
    end
  end

end