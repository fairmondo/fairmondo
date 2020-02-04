#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class BusinessTransactionsController < ApplicationController
  before_action :set_business_transaction, only: [:show, :set_transport_ready]

  def show
    authorize @business_transaction
    redirect_to line_item_group_path @business_transaction.line_item_group
  end

  def export
    authorize :business_transaction, :export?

    @user = current_user
    set_time_range

    exporter = BusinessTransactionExporter.new(@user, @time_range)

    send_data(exporter.csv_string, filename: exporter.filename, type: 'text/csv; charset=utf-8',
                                   disposition: 'attachment')
  end

  def set_transport_ready
    authorize @business_transaction
    @notice = ''

    if @business_transaction.prepare
      CartMailer.courier_notification(@business_transaction).deliver_later
      @notice = I18n.t('transaction.notice.ready_success', id: @business_transaction.id)
    else
      @notice = I18n.t('transaction.notice.ready_failure', id: @business_transaction.id)
    end

    redirect_to line_item_group_path(@business_transaction.line_item_group), notice: @notice
  end

  private

  def set_business_transaction
    @business_transaction = BusinessTransaction.find(params[:id])
  end

  def set_time_range
    year = (params[:date][:year]).to_i
    month = (params[:date][:month]).to_i

    start_time = DateTime.new(year, month).beginning_of_month
    end_time = DateTime.new(year, month).end_of_month
    @time_range = start_time..end_time
  end
end
