require 'faker'

FactoryGirl.define do
  factory :address do
    user
    title           { Faker::Name.prefix }
    first_name      { Faker::Name.first_name }
    last_name       { Faker::Name.last_name }
    address_line_1  { Faker::Address.street_address }
    address_line_2  { Faker::Address.secondary_address }
    zip             { Faker::Address.postcode }
    city            { Faker::Address.city }
    country         'Deutschland'
  end
end
