require 'faker'

FactoryGirl.define do
  factory :ffp do 
    price       { Random.new.rand(10..500) }
    created_at  { Time.now }
    updated_at  { Time.now }
    user_id     { User.all.sample }
    activated   { ["true", "false"].sample }
  end
end