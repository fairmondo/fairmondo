require 'faker'

FactoryGirl.define do
  factory :user, aliases: [:seller,:buyer, :sender] , class: ["PrivateUser", "LegalEntity"].sample do
    email       { Faker::Internet.email }
    password    'password'
    nickname    { Faker::Internet.user_name }
    surname     { Faker::Name.last_name }
    forename    { Faker::Name.first_name }
    privacy     "1"
    legal       "1"
    agecheck    "1"
    recaptcha true


    about_me    { Faker::Lorem.paragraph( rand(7)+1 ) }
    terms    { Faker::Lorem.paragraph( rand(7)+1 ) }
    cancellation    { Faker::Lorem.paragraph( rand(7)+1 ) }
    about    { Faker::Lorem.paragraph( rand(7)+1 ) }
    title { Faker::Name.prefix }
    country { ["Deutschland",Faker::Address.country].sample }
    street { Faker::Address.street_address }
    city { Faker::Address.city }
    zip { Faker::Address.postcode }

    confirmed_at  Time.now

    factory :admin_user do
      admin       true
    end

    factory :german_user do
      country "Deutschland"
      zip "78123"
    end

    factory :private_user, class: 'PrivateUser' do
    end
    factory :legal_entity, class: 'LegalEntity' do
    end
  end

  #Only for attribute generation
  factory :nested_seller_update, class: PrivateUser do
    bank_code {rand(99999999).to_s.center(8, rand(9).to_s)}
    bank_account_number {rand(99999999).to_s.center(8, rand(9).to_s)}
    bank_account_owner Faker::Name.name
    bank_name Faker::Name.name
    #paypal_account Faker::Internet.email
  end

end
