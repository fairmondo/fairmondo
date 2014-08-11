# Read about factories at https://github.com/thoughtbot/factory_girl
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
require 'ffaker'

FactoryGirl.define do
  factory :business_transaction do
    ignore do
      seller { FactoryGirl.create(:seller, :paypal_data) }
      buyer { FactoryGirl.create :user }
      article_attributes { Hash.new }
      article_all_attributes { article_attributes.merge({ seller: seller, quantity: (quantity_bought + 1) }) }
    end

    article { FactoryGirl.create :article, :with_all_payments, :with_all_transports, article_all_attributes }
    line_item_group { FactoryGirl.create :line_item_group, :sold, seller: seller, buyer: buyer }

    selected_transport 'type1'
    selected_payment 'bank_transfer'
    sold_at { Time.now }
    discount_value_cents 0
    quantity_bought 1

    trait :incomplete do
      shipping_address nil
    end

    trait :bought_nothing do
       quantity_bought 0
    end

    trait :bought_ten do
      quantity_bought 10
    end

    trait :bought_five do
      quantity_bought 5
    end

    trait :clear_fastbill do
      after :create do |business_transaction, evaluator|
        business_transaction.seller.update_column(:fastbill_id, nil)
        business_transaction.seller.update_column(:fastbill_subscription_id, nil)
      end
    end

    trait :old do
      after :create do |business_transaction, evaluator|
        business_transaction.update_attribute(:sold_at, 27.days.ago)
      end
    end

    trait :older do
      after :create do |business_transaction, evaluator|
        business_transaction.update_attribute(:sold_at, 44.days.ago)
      end
    end

    trait :discountable do
      article { FactoryGirl.create :article, :with_discount }
    end

    ################ Transports #############

    trait :pickup do
      selected_transport :pickup
    end

    trait :transport_type1 do
      selected_transport :type1
    end

    trait :transport_type2 do
      selected_transport :type2
    end

    ################ Payments #############

    trait :cash do
      selected_payment 'cash'
    end

    trait :paypal do
      selected_payment 'paypal'
      payment { FactoryGirl.create :payment }
    end

    trait :invoice do
      selected_payment 'invoice'
    end

    trait :cash_on_delivery do
      selected_payment :cash_on_delivery
    end

    trait :bank_transfer do
      selected_payment 'bank_transfer'
    end

#    trait :mangopay do
#      selected_payment 'mangopay'
#      payment
#    end
  end
end
