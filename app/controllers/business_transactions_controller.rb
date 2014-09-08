class BusinessTransactionsController < ApplicationController

  def show
    @business_transaction = BusinessTransaction.find(params[:id])
    # no authorize needed as it only redirects, policy will be called on LIG
    redirect_to line_item_group_path @business_transaction.line_item_group
  end
end