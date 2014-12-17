require 'ffaker'

FactoryGirl.define do
  factory :address do
    title           { Faker::NameDE.prefix }
    first_name      { Faker::Name.first_name }
    last_name       { Faker::Name.last_name }
    company_name    { Faker::Company.name }
    address_line_1  { Faker::AddressDE.street_address }
    address_line_2  { Faker::AddressDE.secondary_address }

    # Preselected list of zip for bike courier feature
    zip             { %w(10115 10117 10119 10178 10179 10243 10245 10247 10249 10405 10407 10435 10437 10551 10553 10555 10557 10559 10585 10587 10589 10623 10625 10627 10629 10707 10709 10711 10713 10715 10717 10719 10777 10779 10781 10783 10785 10787 10789 10823 10825 10827 10829 10961 10963 10965 10967 10969 10997 10999 13355 12101 12101 12047 12045 12043 12053 12049).sample }
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
    zip '10999'
    city 'Kleines Dorf'
    country 'Deutschland'
  end


  end


end
