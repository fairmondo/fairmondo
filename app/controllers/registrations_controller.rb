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

    # required for settings form to submit when password is left blank
    if params[:user][:password].blank?
      params[:user].delete("password")
      params[:user].delete("password_confirmation")
    end
 
    @user = User.find(current_user.id)
    @user = @user.becomes(@user.legal_entity ? LegalEntity : PrivateUser)

    if @user.update_attributes(params[:user])
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to dashboard_path(@user)
    else
      render :edit
    end
  end
  
end
