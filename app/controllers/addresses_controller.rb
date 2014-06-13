class AddressesController < ApplicationController
  responders :location
  respond_to :html
  respond_to :js, only: :index, if: lambda { request.xhr? }
  before_filter :set_address, except: [:index, :new, :create]

  def index
    @addresses = current_user.addresses.all
    respond_with @addresses
  end

  def new
    @address = Address.new
  end

  def create
    @address = current_user.addresses.build(params.for(Addresse).refine)
    authorize @address
    respond_with @address
  end

  def edit
    authorize @address
  end

  def update
    authorize @address
    @address.update(params.for(@address).refine)
    respond_with @address
  end

  def destroy
    authorize @address
    @address.destroy
  end

  def show
    authorize @address
    respond_with @address
  end

  private

    def set_address
      @address = current_user.addresses.find(params[:id])
    end
end
