 class RegistrationsController < Devise::RegistrationsController
    
    def create
      if verify_recaptcha
        
        # until now we dont have differnezes between LegalEntity and PrivateUser 
        # so we can call the normal createUser method!
        
          #if params[:user][:legal_entity]
          #   @user = LegalEntity.new(params[:user])
          #else
          #  @user = PrivateUser.new(params[:user])
          #end
          
          #if @user.save
          #  flash[:notice] = I18n.t('devise.confirmations.send_instructions')
          #  redirect_to root_path
          #else
          #  render :new
          #end
        
        super
      else
        build_resource
        clean_up_passwords(resource)
        flash.now[:alert] = t('devise.captcha.error')      
        flash.delete :recaptcha_error
        render :new
      end
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
