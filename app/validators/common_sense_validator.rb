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
    selected_transport = record.selected_transport
    if (selected_payment == 'cash_on_delivery' && selected_transport == 'pickup') or (selected_payment == 'cash' && selected_transport != 'pickup')
      record.errors[attribute] << I18n.t('transaction.errors.combination_invalid',
        selected_transport: I18n.t("enumerize.business_transaction.selected_transport.#{selected_transport}"),
        selected_payment: I18n.t("enumerize.business_transaction.selected_payment.#{selected_payment}")
      )
    end
  end
end