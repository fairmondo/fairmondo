require 'faker'

FactoryGirl.define do
  factory :category do
    name { Faker::Lorem.words( rand(3)+2 ) * " " }
    parent { (Category.all + [nil]).sample}
    
    factory :root_category do
      parent nil
    end
    
  end
  
end
