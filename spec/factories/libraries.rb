# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :library do
    name "MyString"
    public false
    user
     factory :library_with_elements do
        ignore do
          element_count 5
        end
       
       after(:create) do |library, evaluator|
        FactoryGirl.create_list(:library_element, evaluator.element_count, library: library)
      end
     end
  end
end
