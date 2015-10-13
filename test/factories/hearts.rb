#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

FactoryGirl.define do
  factory :heart do
    user
    heartable { FactoryGirl.create :library_with_elements, :public }
  end
end
