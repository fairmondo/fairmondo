#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

FactoryGirl.define do
  factory :feedback do
    text { Faker::Lorem.paragraph(rand(7) + 1) }
    subject { Faker::Lorem.sentence }
    from { Faker::Internet.email }
    to { Faker::Internet.email }
    variety { [:report_article, :get_help, :send_feedback].sample }
    association :user

    trait :report_article do
      variety :report_article
      article_id { FactoryGirl.create(:article).id }
    end
  end
end
