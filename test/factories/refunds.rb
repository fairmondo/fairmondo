#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

FactoryGirl.define do
  factory :refund do
    reason :not_in_stock
    description 'ab' * 80
    business_transaction { FactoryGirl.create :business_transaction, :old }
  end
end
