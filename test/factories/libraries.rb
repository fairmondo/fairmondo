#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

FactoryBot.define do
  factory :library do
    sequence(:name) { |n| "Library_#{n}" }
    association :user

    factory :private_library,               traits: [:private]
    factory :public_library,                traits: [:public]
    factory :private_library_with_elements, traits: [:private, :with_elements]
    factory :public_library_with_elements,  traits: [:public,  :with_elements]

    trait :private do
      public { false }
    end

    trait :public do
      public { true }
    end

    trait :with_elements do
      transient do
        element_count { 5 }
      end

      after(:create) do |library, evaluator|
        create_list(:library_element, evaluator.element_count, library: library)
      end
    end
  end
end
