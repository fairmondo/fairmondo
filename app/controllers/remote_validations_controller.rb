#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class RemoteValidationsController < ApplicationController
  layout false
  skip_before_action :authenticate_user!

  def create
    @validator = RemoteValidation.new params[:model], params[:field], params[:value], additional_params # don't get saved to database, don't need permit, handle request permissions themselves
    render json: { errors: @validator.errors }
  end

  private

  def additional_params
    params.except :model, :field, :value, :controller, :action, :format
  end
end
