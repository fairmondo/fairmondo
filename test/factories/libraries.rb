#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

FactoryGirl.define do
  factory :library do
    sequence(:name) { |n| "LibraryName#{n}" }
    public false
    user

    factory :library_with_elements do
      transient do
        element_count 5
      end

      after(:create) do |library, evaluator|
        FactoryGirl.create_list(:library_element, evaluator.element_count, library: library)
      end
    end

    trait :public do
      public true
    end
  end
end
