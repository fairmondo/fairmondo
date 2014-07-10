class RemoteValidationsController < ApplicationController
  layout false
  skip_before_filter :authenticate_user!

  def create
    @validator = RemoteValidation.new params[:model], params[:field], params[:value], additional_params # doesn't get saved to database, doesn't need permit, handles request permissions itself
    render json: { errors: @validator.errors }
  end

  private
    def additional_params
      params.except :model, :field, :value, :controller, :action, :format
    end
end
