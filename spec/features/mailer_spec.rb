require 'spec_helper'

include Warden::Test::Helpers
#rake routes zeigt die Pfade
describe 'User Email answer by' do
  it "registers a new user" do
      Recaptcha.with_configuration(:public_key => '12345') do
        visit new_user_registration_path
    end
      expect do
        fill_in 'user_nickname',              with: 'nickname'
        fill_in 'user_email',                 with: 'email@example.com'
        fill_in 'user_password',              with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        choose 'user_type_legalentity'
        check 'user_legal'
        check 'user_privacy'
        check 'user_agecheck'
        click_button 'sign_up'
        last_delivery = ActionMailer::Base.deliveries.last
        last_delivery.encoded.should include("-- Diese Nachricht wurde von Fairnopoly, https://beta.fairnopoly.de/, gesendet.")
        last_delivery.encoded.should include("Aufsichtsrat: Kim Stattaus, Anne Schollmeyer, Ernst Neumeister")
      end
  end
  it "reset a password" do
      Recaptcha.with_configuration(:public_key => '12345') do
        visit new_user_password_path
      end
      expect do
        fill_in 'user_email',                 with: 'email@example.com'
        click_button 'sign_up'
        last_delivery = ActionMailer::Base.deliveries.last
        last_delivery.encoded.should include("-- Diese Nachricht wurde von Fairnopoly, https://beta.fairnopoly.de/, gesendet.")
        last_delivery.body.should match ("Aufsichtsrat: Kim Stattaus, Anne Schollmeyer, Ernst Neumeister")
      end
  end
  it"has not recieved authentication" do
      Recaptcha.with_configuration(:public_key => '12345') do
        visit new_user_confirmation_path
  end
      expect do
        fill_in 'user_email',                 with: 'email@example.com'
        click_button 'sign_up'
        last_delivery = ActionMailer::Base.deliveries.last
        last_delivery.encoded.should include("-- Diese Nachricht wurde von Fairnopoly, https://beta.fairnopoly.de/, gesendet.")
        last_delivery.encoded.should include("Aufsichtsrat: Kim Stattaus, Anne Schollmeyer, Ernst Neumeister")
  end
end
end

