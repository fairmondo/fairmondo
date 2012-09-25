FactoryGirl.define do
  factory :userevent do
    user
    event_type { [1, 2, 3].sample }
    appended_object
  end
end