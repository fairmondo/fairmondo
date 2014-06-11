#
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
class RatingsController < ApplicationController
  responders :location, :flash
  respond_to :html

  before_filter :set_user
  before_filter :set_business_transaction, only: :new
  skip_before_filter :authenticate_user!, only: :index

  def new
    @rating = Rating.new(business_transaction_id: params[:business_transaction_id])
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

    def set_business_transaction
      @business_transaction = BusinessTransaction.find(params[:business_transaction_id])
    end
end
