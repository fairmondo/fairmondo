#
#
# == License:
# Fairmondo - Fairmondo is an open-source online marketplace.
# Copyright (C) 2013 Fairmondo eG
#
# This file is part of Fairmondo.
#
# Fairmondo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairmondo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairmondo.  If not, see <http://www.gnu.org/licenses/>.
#
module User::ExtendedAttributes
  extend ActiveSupport::Concern

  included do

    extend Sanitization

    auto_sanitize :nickname, :bank_name
    auto_sanitize :iban, :bic, remove_all_spaces: true
    auto_sanitize :about_me, :terms, :cancellation, :about, method: 'tiny_mce'

    attr_accessor :wants_to_sell
    attr_accessor :bank_account_validation , :paypal_validation
    attr_accessor :fastbill_profile_update

    monetize :unified_transport_price_cents, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 50000 }, :allow_nil => true
    monetize :free_transport_at_price_cents, :numericality => { :greater_than_or_equal_to => 0 }, :allow_nil => true

  end

end
