class BankDetailsController < ApplicationController

  def check
    @result = KontoAPI::valid?( :ktn => permitted_params[:bank_account_number], :blz =>  permitted_params[:bank_code] )
    respond_to do |format|
      format.json { render :json => @result.to_json }
    end
  end

  def get_bank_name
    @result = KontoAPI::bank_name( permitted_params[:bank_code] )
    respond_to do |format|
      format.json { render :json => @result.to_json }
    end
  end

  private
    def permitted_params
      params.permit(:bank_account_number, :bank_code)
    end
end
