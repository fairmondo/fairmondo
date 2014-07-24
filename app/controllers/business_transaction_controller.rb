class BusinessTransactionController < ApplicationController

  def show
    @business_transction = BusinessTransaction.find params[:id]
    authorize @business_transaction
    redirect_to line_item_group_path @business_transaction.line_item_group
  end
end