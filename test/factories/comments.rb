FactoryGirl.define do
  factory :comment do
    user
    library
    text "This is an example comment"
  end
end
