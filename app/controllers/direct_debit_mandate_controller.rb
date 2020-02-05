class DirectDebitMandateController < ApplicationController
  def create
    @user = current_user
    authorize @user

    if params[:add_bank_details].present?
      @user.update(bank_details)

      unless bank_details_added
        redirect_to(params[:after_create_path], notice: t('DebitPayment.bank_details_error'))
        return
      end
    end

    mandate = CreatesDirectDebitMandate.new(@user).create
    redirect_to params[:after_create_path], notice: t('DebitPayment.direct_debit_mandate_created_notice', reference: mandate.reference)
  end

  def revoke
  end

  private

  # todo: move to BankDetailsController
  def bank_details
    bank_details = {}
    bank_details.bank_account_owner = params[:bank_account_owner] if  params[:bank_account_owner].present?
    bank_details.iban = params[:iban] if params[:iban].present?
    bank_details.bic = params[:bic] if params[:bic].present?
    bank_details.bank_name = params[:bank_name] if params[:bank_name].present?
    bank_details
  end
end
