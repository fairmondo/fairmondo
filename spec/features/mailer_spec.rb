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
        last_delivery.encoded.should include("Aufsichtsratsvorsitzender: Kim Stattaus")
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
        last_delivery.body.should match ("Aufsichtsratsvorsitzender: Kim Stattaus")
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
        last_delivery.encoded.should include("Aufsichtsratsvorsitzender: Kim Stattaus")
  end
end
end

describe "Feedback mails" do
  context "for non-signed in user" do
    before do
      visit root_path
      click_link I18n.t('common.text.feedback')
    end

    it "sending feedback" do
      fill_in 'feedback_from',              with: 'email@example.com'
      fill_in 'feedback_subject',           with: 'Das ist die Betreffzeile'
      fill_in 'feedback_text',              with: 'Das ist der Inhalt'
      select(I18n.t('enumerize.feedback.feedback_subject.technics'), from: 'feedback_feedback_subject')
      click_button I18n.t('feedback.actions.send_feedback')
      last_delivery = ActionMailer::Base.deliveries.last
      last_delivery.encoded.should include(I18n.t('enumerize.feedback.feedback_subject.technics'))
      last_delivery.encoded.should include(I18n.t('feedback.details.user_not_logged_in'))
      last_delivery.encoded.should include('Das ist die Betreffzeile')
      last_delivery.encoded.should include('Das ist der Inhalt')
      last_delivery.encoded.should include("Source-Page: #{root_url}")
    end
  end

  context "for signed in user" do
    let(:user) { FactoryGirl.create :user }

    before do
      login_as user
      visit root_path
      click_link I18n.t('common.text.feedback')
    end

    it "sending feedback" do
      article = FactoryGirl.create :article, :user_id => user.id
      fill_in 'feedback_from',              with: 'email@example.com'
      fill_in 'feedback_subject',           with: 'Das ist die Betreffzeile'
      fill_in 'feedback_text',              with: 'Das ist der Inhalt'
      select(I18n.t('enumerize.feedback.feedback_subject.technics'), from: 'feedback_feedback_subject')
      click_button I18n.t('feedback.actions.send_feedback')
      last_delivery = ActionMailer::Base.deliveries.last
      last_delivery.encoded.should include("#{I18n.t('feedback.details.last_uploaded_article_id')}\r\n#{article.id}")
    end
  end
end

