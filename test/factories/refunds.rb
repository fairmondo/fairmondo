#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

FactoryBot.define do
  factory :refund do
    reason { :not_paid }
    description do
      'We spent as much money as we could, and got as little for it as people could '\
      'make up their minds to give us. We were always more or less miserable, and most of our '\
      'acquaintance were in the same condition. There was a gay fiction among us that we were '\
      'constantly enjoying ourselves, and a skeleton truth that we never did. To the best of my '\
      'belief, our case was in the last aspect a rather common one.'
    end
    association :business_transaction, :old
  end
end
