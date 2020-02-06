#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module AddressParams
  extend ActiveSupport::Concern

  ADDRESS_PARAMS = %i(title first_name last_name company_name address_line_1 address_line_2 city zip country).freeze
end
