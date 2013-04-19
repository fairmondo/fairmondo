require 'spec_helper'

describe Message do
  let(:message) { FactoryGirl::create(:message) }

  it { should belong_to :message_sender }
  it { should belong_to :message_recipient }

  it {should validate_presence_of :title}
  it {should validate_presence_of :content}
  it {should validate_presence_of :sender_id}
  it {should validate_presence_of :recipient_id}
end
