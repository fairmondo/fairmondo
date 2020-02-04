#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class RefundsController < ApplicationController
  PERMITTED_PARAMS = %i(reason description).freeze
  responders :flash
  respond_to :html

  def new
    @refund = Refund.new(business_transaction_id: params[:business_transaction_id])
    authorize @refund
    respond_with @refund
  end

  def create
    @refund = Refund.new(params.require(:refund).permit(*PERMITTED_PARAMS))
    @refund.business_transaction = BusinessTransaction.find(params[:business_transaction_id])
    authorize @refund
    @refund.save
    respond_with @refund, location: -> { line_item_group_path(@refund.business_transaction.line_item_group, tab: :payments) }
  end
end
