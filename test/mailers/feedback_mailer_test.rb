require "test_helper"

describe FeedbackMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  it "#feedback_and_help" do
    mail = FeedbackMailer.feedback_and_help Feedback.new(text: 'foobar', variety: 'send_feedback', subject: 'bazfuz'), 'dealer'
    mail.must deliver_to $email_addresses['FeedbackMailer']['send_feedback']['dealer']
    mail.must deliver_from $email_addresses['ArticleMailer']['default_from']
    mail.must have_subject "bazfuz"
  end

  it "#donation_partner" do
    mail = FeedbackMailer.donation_partner Feedback.new(text: 'foobar', variety: 'become_donation_partner', subject: 'Spendenpartner*in Anfrage', from: $email_addresses['ArticleMailer']['default_from'])

    mail.must deliver_to $email_addresses['FeedbackMailer']['become_donation_partner']
    mail.must deliver_from $email_addresses['ArticleMailer']['default_from']
    mail.must have_subject "Spendenpartner*in Anfrage"
  end
end
