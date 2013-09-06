# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reached_goal, :class => 'ReachedGoals' do
    value_1 1
    value_2 1
  end
end
