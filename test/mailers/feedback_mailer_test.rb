require "test_helper"

describe FeedbackMailer do
  describe "#feedback_and_help" do
    let(:user) { FactoryGirl.create(:user) }

    it "should call the mail function with valid params" do
      variety = 'send_feedback'
      a = FeedbackMailer.send("new")
      a.should_receive(:mail).with(
        to: $email_addresses['FeedbackMailer']['send_feedback']['dealer'],
        from: $email_addresses['ArticleMailer']['default_from'], subject: "bazfuz" ).and_return true
      a.feedback_and_help Feedback.new(text: 'foobar', variety: 'send_feedback', subject: 'bazfuz'), 'dealer'
    end

    it "should call the become_donation_partner mail function with valid params" do
      variety = 'become_donation_partner'

      a = FeedbackMailer.send("new")
      a.should_receive(:mail).with(
        to: $email_addresses['FeedbackMailer']['become_donation_partner'],
        from: $email_addresses['ArticleMailer']['default_from'], subject: "Spendenpartner*in Anfrage" ).and_return true
      a.donation_partner Feedback.new(text: 'foobar', variety: 'become_donation_partner', subject: 'Spendenpartner*in Anfrage', from: $email_addresses['ArticleMailer']['default_from'])
    end

  end
end
