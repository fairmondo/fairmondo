#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'ffaker'

FactoryGirl.define do
  factory :social_producer_questionnaire do
    nonprofit_association true
    nonprofit_association_checkboxes [:youth_and_elderly, :art_and_culture, :national_and_vocational_training]

    social_businesses_muhammad_yunus true
    social_businesses_muhammad_yunus_checkboxes [:social_proplem, :dividend, :reinvestment]

    social_entrepreneur true
    social_entrepreneur_checkboxes [:social_proplem, :big_social_groups, :small_social_groups]

    social_entrepreneur_explanation Faker::Lorem.sentence(200)
  end
end
