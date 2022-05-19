#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

FactoryBot.define do
  factory :content do
    sequence(:key) { |n| "page_#{n}" }
    body do
      'If she wounds you, love her. If she tears your heart to pieces - love her, love her, love her!'
    end
  end
end
