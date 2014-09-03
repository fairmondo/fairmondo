class LineItemGroupsController < ApplicationController
  respond_to :html

  before_filter :set_line_item_group
  before_filter :set_tab

  def show
    authorize @line_item_group
    @abacus = Abacus.new(@line_item_group)
    respond_with @line_item_group do |format|
      format.html
      format.js { render layout: 'ajax_replace' }
    end
  end

  private

    def set_line_item_group
      @line_item_group = LineItemGroup.find(params[:id])
    end

    def set_tab
      if params[:tab] == "payments" || (current_user == @line_item_group.buyer && !params[:tab])
        @tab = :payments
      elsif params[:tab] == "transports" || (current_user == @line_item_group.seller && !params[:tab])
        @tab = :transports
      else
        @tab = :rating
      end
    end
end
