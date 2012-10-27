class Notification < ActionMailer::Base
  
  default :from => "tobi@schmidies.de"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification.invitation.subject
  #
  def invitation(id, user, name, email, activation_key)
    
    key = SecureRandom.hex(24)
    @user = user
    @name = name
    @url  = "http://beta.fairnopoly.de/confirm_invitation?id=" + id.to_s + "&key=" + activation_key

    mail(:to => email, :subject => ("Einladung auf Fairnopoly von "+@user.name+" "+@user.surname) )
    
  end
  
  def send_pw(name, email, pw)
    @name = name
    @pw = pw
    
    mail(:to => email, :subject => "Testmail")
    
  end
  
  def send_ffp_confirmed(ffp)
    @ffp = ffp
     mail(:to => @ffp.email, :subject => "Testmail")
  end
  
  def send_ffp_created(ffp)
    @ffp = ffp
    mail(:to => @ffp.email, :subject => "Testmail")
  end
  
end
