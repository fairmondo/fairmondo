#
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :image do
    sequence(:image_file_name) {|n| "image#{n}"}
    image_content_type    "image/png"
    image_file_size       { Random.new.rand(0..5) }

    factory :fixture_image do
      image { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'test.png'), 'image/png') }
    end

    trait :processing do
      image_processing true
    end

  end
end
