class AddressesController < ApplicationController
  responders :location
  respond_to :html, except: :delete
  respond_to :js, only: :index, if: lambda { request.xhr? }
  before_filter :set_address, except: [:index, :new, :create]

  def index
    @addresses = current_user.addresses
    authorize @addresses.first
    respond_with @addresses
  end

  def new
    @address = current_user.addresses.build
    authorize @address
    render layout: false
  end

  def create
    @address = current_user.addresses.build(params.for(Address).refine)
    authorize @address
    respond_with [current_user, @address] if @address.save
  end

  def edit
    authorize @address
    render layout: false
  end

  def update
    authorize @address
    @address.update(params.for(Address).refine)
    respond_with [current_user, @address]
  end

  def show
    authorize @address
    respond_with @address
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
