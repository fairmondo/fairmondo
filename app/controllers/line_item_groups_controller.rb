class LineItemGroupsController < ApplicationController
  respond_to :html

  def show
    @line_item_group = LineItemGroup.find(params[:id])
    authorize @line_item_group
    respond_with @line_item_group
  end
end
