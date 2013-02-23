class DeviseMailer < Devise::Mailer   
  #helper :application # gives access to all helpers defined within `application_helper`.

  def confirmation_instructions(record)
    
    attachments['AGB_Fairnopoly.pdf'] = File.read(Rails.root.join('app/assets/docs/AGB_Fairnopoly_FINAL.pdf'))
    attachments['Datenschutz_Fairnopoly.pdf'] = File.read(Rails.root.join('app/assets/docs/Datenschutz_Fairnopoly_FINAL.pdf'))
    attachments['Testphasenregelung_Fairnopoly.pdf'] = File.read(Rails.root.join('app/assets/docs/Testphasenregelung_Fairnopoly_FINAL.pdf'))
    
    #important to call super for the standard devise mailer
    super
    
  end

end