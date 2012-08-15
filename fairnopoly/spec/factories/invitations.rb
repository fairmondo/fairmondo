FactoryGirl.define do
  factory :invitation do
  sender
  name      { [Faker::Name.first_name] }
  surname   { [Faker::Name.last_name] }
  email     { Faker::Internet.email }
  relation  "friend"
  trusted_1 "true"
  trusted_2 "true"
  end
end