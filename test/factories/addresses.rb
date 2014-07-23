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
    user

    trait :referenced do
      after(:create) { |address| FactoryGirl.create(:line_item_group, payment_address: address) }
    end

  trait :fixture_address do
    title 'Herr'
    first_name 'Hans'
    last_name 'Gutmut'
    company_name 'Goldene Gans gGmbH'
    address_line_1 'Dorfstr. 23'
    address_line_2 'Am Brunnen'
    zip '13747'
    city 'Kleines Dorf'
    country 'Deutschland'
  end


  end


end
