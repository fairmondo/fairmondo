require 'faker'

FactoryGirl.define do
  factory :user, aliases: [:seller, :buyer, :sender, :follower, :followable] do
    email       { Faker::Internet.email }
    password    'password'
    nickname    { Faker::Internet.user_name }
    surname     { Faker::Name.last_name }
    forename    { Faker::Name.first_name }
    privacy     "1"
    legal       "1"
    agecheck    "1"
    recaptcha true
    type { ["PrivateUser", "LegalEntity"].sample }
    
    about_me    { Faker::Lorem.paragraph( rand(7)+1 ) }
    terms    { Faker::Lorem.paragraph( rand(7)+1 ) }
    cancellation    { Faker::Lorem.paragraph( rand(7)+1 ) }
    about    { Faker::Lorem.paragraph( rand(7)+1 ) }
    title { Faker::Name.prefix}
    country {Faker::Address.country}
    street {Faker::Address.street_address}
    city {Faker::Address.city}
    zip {Faker::Address.postcode}

    confirmed_at  Time.now

    factory :admin_user do
      admin       true
    end
    
    factory :german_user do
      country "Deutschland"
      zip "78123"
    end
  end
end