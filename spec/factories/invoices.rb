# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invoice do
    user_id 1
    created_at "2013-08-14 11:15:26"
    updated_at "2013-08-14 11:15:26"
    due_date 14.days.from_now
    state "open"
    paid false
    article_id 1
  end
end
