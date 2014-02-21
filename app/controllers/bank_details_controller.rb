class BankDetailsController < ApplicationController

  def check
    @result = KontoAPI::valid?( ktn: permitted_params[:bank_account_number], blz:  permitted_params[:bank_code] )
    respond_to do |format|
      format.json { render json: @result.to_json }
    end
  end

  def check_iban
    @result = KontoAPI::valid?( iban: permitted_params[:iban] )
    respond_to do |format|
      format.json { render json: @result.to_json }
    end
  end

  def check_bic
    @result = KontoAPI::valid?( bic: permitted_params[:bic] )
    respond_to do |format|
      format.json { render json: @result.to_json }
    end
  end

  # The Konto-API does not support bank_name for bic / iban
  def get_bank_name
    @result = KontoAPI::bank_name( permitted_params[:bank_code] )
    respond_to do |format|
      format.json { render json: @result.to_json }
    end
  end

  private

  def permitted_params
    params.permit(:bank_account_number, :bank_code, :iban, :bic)
  end

end
