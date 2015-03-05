class RemoteValidationsController < ApplicationController
  layout false
  skip_before_filter :authenticate_user!

  def create
    @validator = RemoteValidation.new params[:model], params[:field], params[:value], additional_params # don't get saved to database, don't need permit, handle request permissions themselves
    render json: { errors: @validator.errors }
  end

  private
    def additional_params
      params.except :model, :field, :value, :controller, :action, :format
    end
end
