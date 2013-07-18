#
# Farinopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Farinopoly.
#
# Farinopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Farinopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Farinopoly.  If not, see <http://www.gnu.org/licenses/>.
#
class RegistrationsController < Devise::RegistrationsController

  before_filter :dont_cache, only: [ :edit ]
  skip_before_filter :authenticate_user!, :only => [ :create, :new ]

  #before_filter :check_recaptcha, only: :create

  def create
    params[:user]["recaptcha"] = '0'
    if verify_recaptcha
      params[:user]["recaptcha"] = '1'
    else
      flash.delete :recaptcha_error
    end
    super
  end

  def edit
    @user = User.find(current_user.id)
    @user.build_image unless @user.image
    super
  end

  def update
    @user = User.find(current_user.id)
    params_email = params[:user][:email]

    successfully_updated = if needs_password?(@user, params)
      @user.update_with_password(params[:user])
    else
      # remove the virtual current_password attribute update_without_password
      # doesn't know how to ignore it
      params[:user].delete(:current_password)
      @user.update_without_password(params[:user])
    end

    if successfully_updated
      #show message for reconfirmable if email was changed
      if @user.email != params_email
        set_flash_message :notice, :changed_email
      else
        set_flash_message :notice, :updated
      end

      # Sign in the user bypassing validation in case their password changed
      sign_in @user, bypass: true
      redirect_to user_path(@user)
    else
      resource.image.save if resource.image
      render :edit
    end
  end

  private

  # check if we need password to update user data
  # ie if password or email was changed
  # extend this as needed
  # @api private
  def needs_password?(user, params)
    user.email != params[:user][:email] ||
      !params[:user][:password].blank?
  end

end
