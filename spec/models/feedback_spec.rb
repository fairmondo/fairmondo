require 'spec_helper'

describe Feedback do
  describe "attributes" do
    it { should respond_to 'from' }
    it { should respond_to 'subject' }
    it { should respond_to 'text' }
    it { should respond_to 'to' }
    it { should respond_to 'variety' }
    it { should respond_to 'user_id' }
    it { should respond_to 'article_id' }
    it { should respond_to 'feedback_subject' }
    it { should respond_to 'help_subject' }
  end

  describe "associations" do
    it { should belong_to :user }
    it { should belong_to :article }
  end

  describe "validations" do
    it { should validate_presence_of(:text) }
    it { should validate_presence_of :variety }
    it { should_not allow_value('test@').for :from }
    it { should_not allow_value('@test.').for :from }
    it { should_not allow_value('test.com').for :from }
    it { should allow_value('test@test.museum').for :from }
    it { should allow_value('test@test.co.uk').for :from }


    context "when validating send_feedback" do
      before { subject.variety = 'send_feedback' }
      it { should validate_presence_of :feedback_subject }
      it { should validate_presence_of :subject }
    end

    context "when validating get_help" do
      before { subject.variety = 'get_help' }
      it { should validate_presence_of :help_subject }
      it { should validate_presence_of :subject }
    end
  end

  describe "methods" do
    describe "#set_user_id(current_user)" do
      it "should set the user_id when signed a user is given" do
        user = FactoryGirl.create :user
        f = Feedback.new
        f.set_user_id user
        f.user_id.should eq user.id
      end

      it "should not set the user_id when signed out" do
        f = Feedback.new
        f.set_user_id nil
        f.user_id.should eq nil
      end
    end
  end
end
