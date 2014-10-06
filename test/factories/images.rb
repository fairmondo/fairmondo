#
#
# == License:
# Fairmondo - Fairmondo is an open-source online marketplace.
# Copyright (C) 2013 Fairmondo eG
#
# This file is part of Fairmondo.
#
# Fairmondo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairmondo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairmondo.  If not, see <http://www.gnu.org/licenses/>.
#
include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :image do
    image { fixture_file_upload(Rails.root.join('test', 'fixtures', 'test2.png'), 'image/png') }
    image_content_type    "image/png"
    image_file_size       { Random.new.rand(1..5) }
    after(:create) { |image| image.image_processing = false }

    factory :article_fixture_image, class: "ArticleImage" do
      image { fixture_file_upload(Rails.root.join('test', 'fixtures', 'test.png'), 'image/png') }
    end

    factory :article_image, class: "ArticleImage"

    factory :user_image, class: "UserImage"

    trait :processing do
      image_processing true # for build()
      after(:create) { |image| image.image_processing = true } # for create()
    end

    trait :processed do
      image_processing true
      after(:create) { |image| image.image.reprocess_without_delay! }
    end

  end
end
