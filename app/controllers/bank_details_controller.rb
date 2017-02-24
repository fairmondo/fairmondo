#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class BankDetailsController < ApplicationController
  # Check IBAN and BIC
  [:iban, :bic].each do |value|
    define_method("check_#{ value }") do
      @result = KontoAPI.valid?(value => params[value])
      respond_to do |format|
        format.json { render json: @result.to_json }
      end
    end
  end
end
