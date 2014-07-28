FactoryGirl.define do
  factory :comment do
    user
    commentable { FactoryGirl.create :library }
    text "This is an example comment"
  end
end
