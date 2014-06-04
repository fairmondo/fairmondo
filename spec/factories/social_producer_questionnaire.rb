#
# Farinopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Farinopoly.
#
# Farinopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Farinopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Farinopoly.  If not, see <http://www.gnu.org/licenses/>.
#
require 'ffaker'

FactoryGirl.define do
  factory :social_producer_questionnaire do
      nonprofit_association true
      nonprofit_association_checkboxes [:youth_and_elderly,:art_and_culture,:national_and_vocational_training]

      social_businesses_muhammad_yunus true
      social_businesses_muhammad_yunus_checkboxes [:social_proplem, :dividend, :reinvestment ]

      social_entrepreneur true
      social_entrepreneur_checkboxes [ :social_proplem, :big_social_groups, :small_social_groups ]

      social_entrepreneur_explanation Faker::Lorem.sentence(200)
  end
end
