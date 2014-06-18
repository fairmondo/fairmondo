require_relative '../test_helper'

include Warden::Test::Helpers

# These tests don't actually test anything useful. Please someone rewrite the include statements to actually check the correct content of the email. I also don't think a lot of the Recaptcha statements actually do anything. After you're done, please remove this comment. -KK
=begin

feature 'User Mailer' do
  scenario 'new user registerson registration' do
    visit new_user_registration_path
    within '.registrations-form' do
      fill_in 'user_nickname',              with: 'nickname'
      fill_in 'user_email',                 with: 'email@example.com'
      fill_in 'user_password',              with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      choose 'user_type_legalentity'
      check 'user_legal'
      check 'user_agecheck'
      click_button 'sign_up'
    end
    last_delivery = ActionMailer::Base.deliveries.last
    last_delivery.body.must_include("-- Diese Nachricht wurde von Fairnopoly, https://beta.fairnopoly.de/, gesendet.")
    last_delivery.body.must_include("Aufsichtsratsvorsitzender: Kim Stattaus")

  end

  scenario "user resets his password" do
    visit new_user_password_path
    within 'Content' do
      fill_in 'user_email',                 with: 'email@example.com'
      click_button 'sign_up'
    end
    last_delivery = ActionMailer::Base.deliveries.last
    last_delivery.body.must_include("-- Diese Nachricht wurde von Fairnopoly, https://beta.fairnopoly.de/, gesendet.")
    last_delivery.body.must_include("Aufsichtsratsvorsitzender: Kim Stattaus")

  end

  scenario "user resends confirmation mail" do
    visit new_user_confirmation_path

    within 'Content' do
      fill_in 'user_email',                 with: 'email@example.com'
      click_button 'sign_up'
    end
    last_delivery = ActionMailer::Base.deliveries.last
    last_delivery.encoded.must_include("-- Diese Nachricht wurde von Fairnopoly, https://beta.fairnopoly.de/, gesendet.")
    last_delivery.encoded.must_include("Aufsichtsratsvorsitzender: Kim Stattaus")

  end
end

feature "Feedback Mailer" do
  scenario "signed-out user gives feedback" do
    visit root_path
    click_link I18n.t('common.text.feedback')
    fill_in 'feedback_from',              with: 'email@example.com'
    fill_in 'feedback_subject',           with: 'Das ist die Betreffzeile'
    fill_in 'feedback_text',              with: 'Das ist der Inhalt'
    select(I18n.t('enumerize.feedback.feedback_subject.technics'), from: 'feedback_feedback_subject')
    click_button I18n.t('feedback.actions.send_feedback')
    last_delivery = ActionMailer::Base.deliveries.last
    last_delivery.encoded.must_include(I18n.t('enumerize.feedback.feedback_subject.technics'))
    last_delivery.encoded.must_include(I18n.t('feedback.details.user_not_logged_in'))
    last_delivery.encoded.must_include('Das ist die Betreffzeile')
    last_delivery.encoded.must_include('Das ist der Inhalt')
    last_delivery.encoded.must_include("Source-Page: http://www.example.com/")

  end

  scenario "signed-in user gives feedback" do
    let(:user) { FactoryGirl.create :user }
    login_as user
    visit root_path
    click_link I18n.t('common.text.feedback')

    article = FactoryGirl.create :article, :user_id => user.id
    fill_in 'feedback_from',              with: 'email@example.com'
    fill_in 'feedback_subject',           with: 'Das ist die Betreffzeile'
    fill_in 'feedback_text',              with: 'Das ist der Inhalt'
    select(I18n.t('enumerize.feedback.feedback_subject.technics'), from: 'feedback_feedback_subject')
    click_button I18n.t('feedback.actions.send_feedback')
    last_delivery = ActionMailer::Base.deliveries.last
    last_delivery.encoded.must_include("#{I18n.t('feedback.details.last_uploaded_article_id')}\r\n#{article.id}")

  end
end


=end
