require 'ffaker'

FactoryGirl.define do
  factory :address do
    title           { Faker::NameDE.prefix }
    first_name      { Faker::Name.first_name }
    last_name       { Faker::Name.last_name }
    company_name    { Faker::Company.name }
    address_line_1  { Faker::AddressDE.street_address }
    address_line_2  { Faker::AddressDE.secondary_address }
    zip             { Faker::AddressDE.zip_code }
    city            { Faker::AddressDE.city }
    country         'Deutschland'
    after(:create) { |address| FactoryGirl.create(:user, standard_address: address) }

    trait :referenced do
      after(:create) { |address| FactoryGirl.create(:line_item_group, payment_address: address) }
    end

  end


end
