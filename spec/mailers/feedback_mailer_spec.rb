require "spec_helper"

describe FeedbackMailer do
  describe "#feedback_and_help" do
    let(:user) { FactoryGirl.create(:user) }

    it "should call the mail function with valid params" do
      variety = 'send_feedback'
      a = FeedbackMailer.send("new")
      a.should_receive(:mail).with(to: $email_addresses['FeedbackMailer']['send_feedback']['dealer'], from: $email_addresses['ArticleMailer']['default_from'], subject: "bazfuz" ).and_return true
      a.feedback_and_help Feedback.new(text: 'foobar', variety: 'send_feedback', subject: 'bazfuz'), 'dealer'
    end
  end
end
