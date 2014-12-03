class BusinessTransactionsController < ApplicationController
  before_filter :set_business_transaction

  def show
    @business_transaction = BusinessTransaction.find(params[:id])
    # no authorize needed as it only redirects, policy will be called on LIG
    redirect_to line_item_group_path @business_transaction.line_item_group
  end

  def set_transport_ready
    authorize @business_transaction

    if @business_transaction.ship
      CartMailer.delay.courier_notification(@business_transaction.line_item_group)

      redirect_to line_item_groups_path(@business_transaction.line_item_group)
    end
  end

  private

    def set_business_transaction
      @business_transaction = BusinessTransaction.find(params[:id])
    end
end
