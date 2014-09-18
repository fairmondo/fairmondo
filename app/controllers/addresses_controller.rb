class AddressesController < ApplicationController
  respond_to :html, only: [:edit, :new]
  respond_to :js, if: lambda { request.xhr? }
  before_filter :set_address, except: [ :new, :create]

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
    set_standard = (@address.is_referenced? && @address.is_standard_address?)
    @address = @address.duplicate_if_referenced!
    if @address.save
      @address.user.update_column(:standard_address_id, @address.id) if set_standard
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
