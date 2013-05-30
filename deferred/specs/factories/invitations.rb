#
# Farinopoly - Fairnopoly is an open-source online marketplace soloution.
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
FactoryGirl.define do
  factory :invitation do
    sender
    name      { [Faker::Name.first_name] }
    surname   { [Faker::Name.last_name] }
    email     { Faker::Internet.email }
    relation  "friend"
    trusted_1 true
    trusted_2 true

    factory :activated_invitation do
      activated true
    end

    factory :wrong_invitation do
      activation_key "xyz"
    end
  end
end
