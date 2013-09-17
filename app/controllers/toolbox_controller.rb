class ToolboxController < ApplicationController
  respond_to :js, :json

  skip_before_filter :authenticate_user!, only: [ :session,:confirm ]

  def session
    respond_to do |format|
      #Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name) #for testing purposes
      format.json { render status: 200, json: { expired: current_user.nil? } }
    end
  end

  def confirm
    respond_to do |format|
      format.js
    end
  end

end
