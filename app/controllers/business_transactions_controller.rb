class BusinessTransactionsController < ApplicationController
  before_filter :set_business_transaction

  def show
    # no authorize needed as it only redirects, policy will be called on LIG
    redirect_to line_item_group_path @business_transaction.line_item_group
  end

  def set_transport_ready
    authorize @business_transaction
    notice = ''

    if @business_transaction.prepare
      CartMailer.delay.courier_notification(@business_transaction)
      notice = I18n.t('transaction.notice.ready_success', id: @business_transaction.id)
    else
      notice = I18n.t('transaction.notice.ready_failure', id: @business_transaction.id)
    end

    redirect_to line_item_group_path(@business_transaction.line_item_group), notice: notice
  end

  private

    def set_business_transaction
      @business_transaction = BusinessTransaction.find(params[:id])
    end
end
