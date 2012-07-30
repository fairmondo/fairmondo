class Notification < ActionMailer::Base
  
  default :from => "tobi@schmidies.de"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification.invitation.subject
  #
  def invitation(user, name, email)
    key = SecureRandom.hex(24)
    @user = user
    @name = name
    @url  = "http://127.0.0.1:8080/users/sign_up/" + key

    mail(:to => email, :subject => "Testmail")
    
  end
  
end
