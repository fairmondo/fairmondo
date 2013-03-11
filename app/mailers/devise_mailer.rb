class DeviseMailer < Devise::Mailer   
  #helper :application # gives access to all helpers defined within `application_helper`.

  
  def welcome_mail(record)
    
    attachments['AGB_Fairnopoly.pdf'] = File.read(Rails.root.join('app/assets/docs/AGB_Fairnopoly_FINAL.pdf'))
    attachments['Datenschutz_Fairnopoly.pdf'] = File.read(Rails.root.join('app/assets/docs/Datenschutz_Fairnopoly_FINAL.pdf'))
    attachments['Testphasenregelung_Fairnopoly.pdf'] = File.read(Rails.root.join('app/assets/docs/Testphasenregelung_Fairnopoly_FINAL.pdf'))
    
    devise_mail(record, :confirmation_instructions)
    
  end

end