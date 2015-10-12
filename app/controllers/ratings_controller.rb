#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class RatingsController < ApplicationController
  responders :location, :flash
  respond_to :html

  before_action :set_user
  # before_filter :set_business_transaction, only: :new
  before_action :set_line_item_group, only: :new
  skip_before_action :authenticate_user!, only: :index

  def new
    @rating = Rating.new(line_item_group_id: @line_item_group.id)
    authorize @rating
    respond_with @rating
  end

  def create
    @rating = Rating.new(params.for(Rating).refine)
    @rating.rating_user = current_user
    @rating.rated_user = @user
    authorize @rating
    @rating.save
    respond_with(@rating, location: -> { user_path(current_user) })
  end

  def index
    @ratings = @user.ratings.page(params[:page])
    respond_with(@ratings)
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  # def set_business_transaction
  #  @business_transaction = BusinessTransaction.find(params[:business_transaction_id])
  # end

  def set_line_item_group
    @line_item_group = LineItemGroup.find(params[:line_item_group_id])
  end
end
