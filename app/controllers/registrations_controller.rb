#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class RegistrationsController < Devise::RegistrationsController
  include AddressParams
  include UserParams

  before_action :dont_cache, only: [:edit]
  before_action :configure_permitted_parameters
  skip_before_action :authenticate_user!, only: [:create, :new]

  # GET /resource/sign_up
  def new
    build_resource({})

    # Check if parameters have been provided by a landing page and set object attributes accordingly
    resource.assign_attributes(params.require(:external_user).permit(*USER_CREATE_PARAMS)) if params[:external_user]

    if devise_mapping.validatable?
      @minimum_password_length = resource_class.password_length.min
    end
    respond_with self.resource
  end

  def create
    super
    if resource.valid? && resource.voluntary_contribution.present?
      RegistrationsMailer.voluntary_contribution_email(params[:user][:email],
                                                       params[:user][:voluntary_contribution].to_i).deliver_later
    end
  end

  def edit
    @user = User.find(current_user.id)
    check_incomplete_profile!(@user)
    super
  end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{ resource_name }").to_key)

    address_params = params[:address] ? params.require(:address).permit(*ADDRESS_PARAMS) : {}
    resource.build_standard_address_from address_params.to_h
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    revoke_direct_debit_mandate_if_bank_details_changed(resource, params)

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

  def revoke_direct_debit_mandate_if_bank_details_changed(resource, params)
    mandate = resource.active_direct_debit_mandate
    if mandate.present? &&
       params[:user][:direct_debit_confirmation] != '1'
      if params[:user][:iban]               != resource.iban ||
         params[:user][:bic]                != resource.bic ||
         params[:user][:bank_account_owner] != resource.bank_account_owner
        mandate.revoke!
        set_flash_message :alert, :direct_debit_mandate_revoked
      end
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

    if resource.direct_debit_confirmation == '1'
      creator = CreatesDirectDebitMandate.new(resource)
      creator.create
    end

    bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?
    respond_with resource, location: after_update_path_for(resource)
  end

  def actions_for_unsuccessful_update_for resource
    clean_up_passwords resource
    resource.image.save if resource.image
    respond_with resource
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: USER_CREATE_PARAMS)
    devise_parameter_sanitizer.permit(:account_update, keys: user_update_params)
  end

  def user_update_params
    if current_user.is_a? LegalEntity
      USER_UPDATE_PARAMS + USER_UPDATE_LEGAL_ENTITY_PARAMS
    else
      USER_UPDATE_PARAMS
    end
  end
end
