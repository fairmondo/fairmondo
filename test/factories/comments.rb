#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

FactoryBot.define do
  factory :comment do
    text do
      'Heaven knows we need never be ashamed of our tears, for they are rain upon the blinding '\
      'dust of earth, overlying our hard hearts.'
    end

    association :user
    association :commentable, factory: :library
  end
end
