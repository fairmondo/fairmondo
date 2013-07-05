FactoryGirl.define do
  factory :content do
    sequence(:key) {|n| "page#{n}" }
    body { Faker::Lorem.paragraph( rand(7)+1 ) }
  end
end
