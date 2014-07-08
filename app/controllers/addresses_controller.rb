class AddressesController < ApplicationController
  responders :location
  respond_to :html, only: [:edit, :new]
  respond_to :js, if: lambda { request.xhr? }
  before_filter :set_address, except: [:index, :new, :create]

  #def index
  #  @addresses = current_user.addresses
  #  authorize @addresses.first
  #  respond_with [current_user, @addresses]
  #end

  def new
    @address = current_user.addresses.build
    authorize @address
    render layout: false
  end

  def create
    @address = current_user.addresses.build(params.for(Address).refine)
    authorize @address
    if @address.save
      redirect_to user_address_path(current_user, @address, radio: params[:radio])
    end
  end

  def edit
    authorize @address
    render layout: false
  end

  def update
    authorize @address
    if @address.update(params.for(Address).refine)
      redirect_to user_address_path(current_user, @address, radio: params[:radio])
    end
  end

  def show
    authorize @address
    respond_with current_user, @address
  end

  def destroy
    authorize @address
    @address.destroy
  end

  private

    def set_address
      @address = current_user.addresses.find(params[:id])
    end
end
