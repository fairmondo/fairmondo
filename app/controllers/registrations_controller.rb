class RegistrationsController < Devise::RegistrationsController
  
   before_filter :authenticate_user!, :except => [:create,:new]
  
  def create
    if verify_recaptcha
      params[:user]["recaptcha"] = true
    else
      flash.delete :recaptcha_error
    end
    super
  end

  

  def update
    @user_ = User.find(current_user.id)
    params_email = params[:user][:email]
    
    successfully_updated = if needs_password?(@user, params)
      # Workaround
      # the LegalEntity.update_with_password does not work ??
      # see: https://github.com/plataformatec/devise/blob/master/lib/devise/models/database_authenticatable.rb
      # http://stackoverflow.com/questions/6146317/is-subclassing-a-user-model-really-bad-to-do-in-rails
      # http://stackoverflow.com/questions/14492180/validation-error-on-update-attributes-of-a-subclass-sti
      if @user_.update_with_password(params[:user])
        # for workaround, else email is send 2 times
        params[:user].delete("email")
        @user.update_without_password(params[:user])
      else
      false
      end
    else
    # remove the virtual current_password attribute update_without_password
    # doesn't know how to ignore it
      params[:user].delete("current_password")
      params[:user].delete("password")
      params[:user].delete("password_confirmation")
      @user.update_without_password(params[:user])
    end

    if successfully_updated
      #show message for reconfirmable if email was changed
      if @user.email != params_email
        set_flash_message :notice, :changed_email
      else
        set_flash_message :notice, :updated
      end
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  # check if we need password to update user data
  # ie if password was changed
  # extend this as needed
  def needs_password?(user, params)
    user.email != params[:user][:email] ||
    !params[:user][:password].blank?
  end

end
