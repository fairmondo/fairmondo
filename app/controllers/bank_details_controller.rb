class BankDetailsController < ApplicationController

  def check
    @result = KontoAPI::valid?( :ktn => params[:bank_account_number], :blz =>  params[:bank_code] )
    respond_to do |format|
      format.json { render :json => @result.to_json }
    end
  end

  def get_bank_name
    @result = KontoAPI::bank_name( params[:bank_code] )
    respond_to do |format|
      format.json { render :json => @result.to_json }
    end
  end

end
