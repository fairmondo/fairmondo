module Devise::Models::Confirmable
 
  # Override Devise's own method. This one is called only on user creation, not on subsequent address modifications.
  def send_on_create_confirmation_instructions
    DeviseMailer.welcome_mail(self).deliver
  end
  
    # Send confirmation instructions by email
    def send_confirmation_instructions
      
      resend = !self.confirmation_token.blank?
      
      self.confirmation_token = nil if reconfirmation_required?
      @reconfirmation_required = false

      generate_confirmation_token! if self.confirmation_token.blank?

      opts = pending_reconfirmation? ? { :to => unconfirmed_email } : { }
      
      if resend
        DeviseMailer.welcome_mail(self).deliver
      else
        send_devise_notification(:confirmation_instructions, opts)
      end
   
    end
 
end