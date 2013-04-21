require 'faker'

FactoryGirl.define do
  factory :message do
  	message_sender
  	message_recipient

    title { Faker::Lorem.sentence(rand(3)+1).chomp '.' }
    content { Faker::Lorem.paragraph(rand(7)+1) }
  end
end
