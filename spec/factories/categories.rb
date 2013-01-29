require 'faker'

FactoryGirl.define do
  factory :category do
    name { Faker::Lorem.words( rand(3)+2 ) * " " }
    parent nil
    
    factory :child_category do
      parent { Category.all.sample || Factory.create(:category)}
    end
    
  end
  
end
