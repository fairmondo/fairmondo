#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

include ActionDispatch::TestProcess

FactoryBot.define do
  factory :image do
    image { fixture_file_upload(Rails.root.join('test', 'fixtures', 'test2.png'), 'image/png') }
    image_content_type { 'image/png' }
    image_file_size { Random.new.rand(1..5) }
    after(:create) { |image| image.image_processing = false }

    factory :article_fixture_image, class: 'ArticleImage' do
      image { fixture_file_upload(Rails.root.join('test', 'fixtures', 'test.png'), 'image/png') }
    end

    factory :article_image, class: 'ArticleImage'

    factory :user_image, class: 'UserImage'

    trait :processing do
      image_processing { true } # for build()
      after(:create) { |image| image.image_processing = true } # for create()
    end

    trait :processed do
      image_processing { true }
      after(:create) { |image| image.image.reprocess_without_delay! }
    end
  end
end
