class DirectDebitMandateController < ApplicationController
  def create
    @user = current_user
    authorize @user
    mandate = CreatesDirectDebitMandate.new(@user).create

    redirect_to(params[:after_create_path], notice:t("DebitPayment.direct_debit_mandate_created"))
  end

  def revoke
  end
end
