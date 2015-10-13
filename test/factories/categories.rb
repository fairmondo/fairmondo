#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'ffaker'

FactoryGirl.define do
  factory :category do
    name { Faker::Lorem.words(rand(3) + 2) * ' ' }
    parent nil

    factory :child_category do
      parent { Category.all.sample || Factory.create(:category) }
    end
  end
end
