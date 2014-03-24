require 'spec_helper'

include Warden::Test::Helpers

# These tests don't actually test anything useful. Please someone rewrite the include statements to actually check the correct content of the email. I also don't think a lot of the Recaptcha statements actually do anything. After you're done, please remove this comment. -KK
describe 'User Mailer' do
  describe 'on registration' do
    it "should send a registration email" do
      visit new_user_registration_path

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

    it "should send a password reset email" do
      visit new_user_password_path

      expect do
        fill_in 'user_email',                 with: 'email@example.com'
        click_button 'sign_up'
        last_delivery = ActionMailer::Base.deliveries.last
        last_delivery.encoded.should include("-- Diese Nachricht wurde von Fairnopoly, https://beta.fairnopoly.de/, gesendet.")
        last_delivery.body.should match("Aufsichtsratsvorsitzender: Kim Stattaus")
      end
    end

    it "should send a new confirmation email" do
      visit new_user_confirmation_path

      expect do
        fill_in 'user_email',                 with: 'email@example.com'
        click_button 'sign_up'
        last_delivery = ActionMailer::Base.deliveries.last
        last_delivery.encoded.should include("-- Diese Nachricht wurde von Fairnopoly, https://beta.fairnopoly.de/, gesendet.")
        last_delivery.encoded.should include("Aufsichtsratsvorsitzender: Kim Stattaus")
      end
    end
  end
end

describe "Feedback Mailer" do
  context "for signed-out users" do
    before do
      visit root_path
      click_link I18n.t('common.text.feedback')
    end

    it "should send a feedback email with the correct contents" do
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

  context "for signed-in users" do
    let(:user) { FactoryGirl.create :user }

    before do
      login_as user
      visit root_path
      click_link I18n.t('common.text.feedback')
    end

    it "should send a feedback email with the correct contents" do
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

