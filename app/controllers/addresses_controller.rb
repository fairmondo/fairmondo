#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class AddressesController < ApplicationController
  respond_to :html, only: [:edit, :new]
  respond_to :js, if: lambda { request.xhr? }
  before_action :set_address, except: [:new, :create]

  def new
    @address = current_user.addresses.build
    authorize @address
    render layout: false
  end

  def create
    @address = current_user.addresses.build(params.for(Address).refine)
    authorize @address
    if @address.save
      render :create
    else
      render :new
    end
  end

  def edit
    authorize @address
    render layout: false
  end

  def update
    authorize @address
    @address.assign_attributes(params.for(Address).refine)
    @address = @address.duplicate_if_referenced!
    if @address.save
      render :update
    else
      render :edit
    end
  end

  def destroy
    authorize @address
    if @address.is_referenced?
      @address.stash!
    else
      @address.destroy
    end
  end

  private

  def set_address
    @address = current_user.addresses.find(params[:id])
  end
end
