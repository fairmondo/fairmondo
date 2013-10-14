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
class SupportedOptionValidator < ActiveModel::EachValidator
  # Check if seller allowed [transport/payment] type of [type] for the associated article. Also sets error message
  #
  # @api public
  # @param record [Transaction] currently only supports transactions
  # @param attribute [String] ATM: selected_payment or selected_transport
  # @param type [String] The type to check
  # @return [undefined]
  def validate_each(record, attribute, type)
    if type
      attribute_core = attribute[9..-1] #no 'selected_'
      unless record.article.send "#{attribute_core}_#{type}?"
        record.errors[attribute] << I18n.t("transaction.errors.#{attribute_core}_not_supported")
      end
    end
  end
end