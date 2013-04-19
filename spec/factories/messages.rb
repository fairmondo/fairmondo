# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    title "MyString"
    content "MyText"
    sender_id User.all.sample && User.all.sample.id
    recipient_id User.all.sample && User.all.sample.id

    # after(:build) do |msg|
    #   msg.sender_id = sender.id
    #   msg.recipient_id = recipient.id
    # end
  end
end
