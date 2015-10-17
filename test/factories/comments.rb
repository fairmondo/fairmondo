#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

FactoryGirl.define do
  factory :comment do
    text 'Heaven knows we need never be ashamed of our tears, for they are rain upon the blinding '\
      'dust of earth, overlying our hard hearts.'
    association :user
    association :commentable, factory: :library
  end
end
