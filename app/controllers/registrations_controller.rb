#
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
class RegistrationsController < Devise::RegistrationsController

  before_filter :dont_cache, only: [ :edit ]
  before_filter :configure_permitted_parameters
  skip_before_filter :authenticate_user!, only: [ :create, :new ]

  def edit
    @user = User.find(current_user.id)
    @address = nil

    if @user.addresses.empty?
      @standard_address = @user.addresses.build
    else
      @standard_address = @user.standard_address
    end

    check_incomplete_profile!(@user)
    @user.valid?
    super
  end


  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)
    successfully_updated  = update_account(account_update_params)

    address = nil
    if resource.addresses.empty? && params[:address]
      resource.standard_address = resource.addresses.build(params.for(Address).refine)
      resource.standard_address.save
      #save_standard_address(resource, address)
    elsif resource.standard_address && params[:address]
      resource.standard_address.update(params.for(Address).refine)
    end

    if successfully_updated
      if is_navigational_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
           :changed_email : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, bypass: true
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      resource.image.save if resource.image
      respond_with resource
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

    def after_update_path_for(resource_or_scope)
      user_path(resource_or_scope)
    end

    def check_incomplete_profile!(user)
      user.wants_to_sell = true if params[:incomplete_profile]
    end

    def update_account(account_update_params)
      if needs_password?(resource, params)
       resource.update_with_password(account_update_params)
      else
        # remove the virtual current_password attribute update_without_password
        # doesn't know how to ignore it
        account_update_params.delete(:current_password) if account_update_params
        resource.update_without_password(account_update_params)
      end
    end

    def save_standard_address(user, address)
      if address && !address.persisted?
        address.save
        user.update(standard_address_id: address.id)
      end
    end

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) do |u|
        u.for(User.new).as(resource).on(:create).refine
      end
      devise_parameter_sanitizer.for(:account_update) do |u|
        u.for(User.new).as(resource).on(:update).refine# permit(*UserRefinery.new(resource).default, :current_password)
      end
    end
end
