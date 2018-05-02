class DirectDebitMandateController < ApplicationController
  def create
    @user = current_user
    authorize @user

    if params[:add_bank_details].present?
      bank_details_added = add_bank_details

      unless bank_details_added
        redirect_to(params[:after_create_path], notice: t('DebitPayment.bank_details_error'))
        return
      end
    end

    mandate = CreatesDirectDebitMandate.new(@user).create
    redirect_to params[:after_create_path], notice: t('DebitPayment.direct_debit_mandate_created_notice', reference: mandate.reference)
  end

  # todo: move to BankDetailsController
  def add_bank_details
      @user.bank_account_owner = params[:bank_account_owner] if  params[:bank_account_owner].present?
      @user.iban = params[:iban] if params[:iban].present?

      @user.bic = params[:bic] if params[:bic].present?
      @user.bank_name = params[:bank_name] if params[:bank_name].present?

      @user.save
  end

  def revoke
  end
end
