 class RegistrationsController < Devise::RegistrationsController
    
    def create
      
      
      if verify_recaptcha
        params[:user]["recaptcha"] = true
      else
        flash.delete :recaptcha_error
      end
      super
    end
    
  def edit
    if current_user  
      @user = current_user.becomes(current_user.legal_entity ? LegalEntity : PrivateUser)   
      super
    else
      render :new
    end
  end
  
  def update

 
    @user = User.find(current_user.id)
    @user = @user.becomes(@user.legal_entity ? LegalEntity : PrivateUser)

     successfully_updated = if needs_password?(@user, params)
       
        @user.update_with_password(params[:user])
        
     else
        # remove the virtual current_password attribute update_without_password
        # doesn't know how to ignore it
        params[:user].delete("current_password")
        params[:user].delete("password")
        params[:user].delete("password_confirmation")
        
        @user.update_without_password(params[:user])
     end

    if successfully_updated
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to dashboard_path(@user)
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
