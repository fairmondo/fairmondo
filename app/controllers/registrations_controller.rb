#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class RegistrationsController < Devise::RegistrationsController
  before_action :dont_cache, only: [:edit]
  before_action :configure_permitted_parameters
  skip_before_action :authenticate_user!, only: [:create, :new]

  # GET /resource/sign_up
  def new
    build_resource({})

    # Check if parameters have been provided by a landing page and set object attributes accordingly
    resource.assign_attributes(params[:external_user].for(resource).on(:create).refine) if params[:external_user]

    if devise_mapping.validatable?
      @minimum_password_length = resource_class.password_length.min
    end
    respond_with self.resource
  end

  def edit
    @user = User.find(current_user.id)
    check_incomplete_profile!(@user)
    super
  end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{ resource_name }").to_key)
    address_params = params[:address] ? params.for(Address).refine : {}
    resource.build_standard_address_from address_params
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    if update_account(account_update_params)
      actions_for_successful_update_for resource, prev_unconfirmed_email
    else
      actions_for_unsuccessful_update_for resource
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
    if params[:incomplete_profile]
      user.wants_to_sell = true
      user.valid?
    end
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

  def actions_for_successful_update_for resource, prev_unconfirmed_email = nil
    resource.save_already_validated_standard_address!

    if is_navigational_format?
      flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
        :changed_email : :updated
      set_flash_message :notice, flash_key
    end

    sign_in resource_name, resource, bypass: true
    respond_with resource, location: after_update_path_for(resource)
  end

  def actions_for_unsuccessful_update_for resource
    clean_up_passwords resource
    resource.image.save if resource.image
    respond_with resource
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.for(User.new).as(resource).on(:create).refine
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.for(User.new).as(resource).on(:update).refine # permit(*UserRefinery.new(resource).default, :current_password)
    end
  end
end
