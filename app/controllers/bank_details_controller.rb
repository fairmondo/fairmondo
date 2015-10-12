#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class BankDetailsController < ApplicationController
  def check
    @result = KontoAPI.valid?(ktn: params[:bank_account_number],
                              blz: params[:bank_code])
    respond_to do |format|
      format.json { render json: @result.to_json }
    end
  end

  # Check IBAN and BIC
  [:iban, :bic].each do |value|
    define_method("check_#{ value }") do
      @result = KontoAPI.valid?(value => params[value])
      respond_to do |format|
        format.json { render json: @result.to_json }
      end
    end
  end

  # The Konto-API does not support bank_name for bic / iban
  def acquire_bank_name
    @result = KontoAPI.bank_name(params[:bank_code])
    respond_to do |format|
      format.json { render json: @result.to_json }
    end
  end
end
