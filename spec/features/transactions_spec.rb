#
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
require 'spec_helper'
include Warden::Test::Helpers

describe 'Transaction' do

  let(:transaction) { FactoryGirl.create :transaction }
  let(:article) { transaction.article }
  let(:seller) { transaction.article.seller }
  let(:user) { FactoryGirl.create :user }

  describe "#edit" do

    context "for a logged-in user" do
      before { login_as user }

      describe "step 1" do
        it "should show the correct data and fields" do
          visit edit_transaction_path transaction

          page.should have_content I18n.t 'transaction.edit.heading'

          # Should display article data
          page.should have_content I18n.t 'common.text.product'
          page.should have_content article.title
          page.should have_content I18n.t 'common.text.seller'
          page.should have_content seller.fullname

          # Should display shipping selection
          page.should have_content I18n.t 'transaction.edit.transport'
          page.should have_selector 'select', text: I18n.t('enumerize.transaction.selected_transport.pickup')

          # Should display payment selection
          page.should have_content I18n.t 'transaction.edit.payment'
          page.should have_selector 'select', text: I18n.t('enumerize.transaction.selected_payment.cash')

          # Should display impressum
          page.should have_content I18n.t 'transaction.edit.impressum', name: seller.fullname

          # Should display buyer's address
          page.should have_content I18n.t 'transaction.edit.address'
          page.should have_content user.fullname
          page.should have_content user.street
          page.should have_content user.zip
          page.should have_content user.city
          page.should have_content user.country
        end

        it "should lead to step 2" do
          visit edit_transaction_path transaction

          page.should_not have_button I18n.t 'transaction.actions.purchase'
          click_button I18n.t 'common.actions.continue'

          page.should have_button I18n.t 'transaction.actions.purchase'
        end
      end

      describe "step 2" do
        context "given valid data" do
          it "should have the correct fields and texts" do
            visit edit_transaction_path transaction, transaction: {"selected_transport" => "pickup", "selected_payment" => "cash"}

            # Should have pre-filled hidden fields
            page.should have_css 'input#transaction_selected_transport[@type=hidden][@value=pickup]'
            page.should have_css 'input#transaction_selected_payment[@type=hidden][@value=cash]'

            # Should display article data
            page.should have_content I18n.t 'common.text.product'
            page.should have_content article.title
            page.should have_content I18n.t 'common.text.seller'
            page.should have_content seller.fullname

            # Should display chosen payment type
            page.should have_content I18n.t 'transaction.edit.payment_type'
            page.should have_content I18n.t 'enumerize.transaction.selected_payment.cash'

            # Should display chosen transport type (specs for transport provider further down)
            page.should have_content I18n.t 'transaction.edit.transport_type'
            page.should have_content I18n.t 'enumerize.transaction.selected_transport.pickup'

            # Should display buyer's address
            page.should have_content I18n.t 'transaction.edit.address'
            page.should have_content user.fullname
            page.should have_content user.street
            page.should have_content user.zip
            page.should have_content user.city
            page.should have_content user.country

            # Should display terms
            page.should have_content I18n.t 'transaction.edit.terms', name: seller.fullname

            # Should display declaration of revocation
            page.should have_content I18n.t 'transaction.edit.cancellation', name: seller.fullname

            # Should display a checkbox for the terms
            page.should have_css 'input#transaction_tos_accepted[@type=checkbox]'

            # Should display buttons
            page.should have_link I18n.t 'common.actions.back'
            page.should have_button I18n.t 'transaction.actions.purchase'
          end

          it "should submit the data successfully" do
            visit edit_transaction_path transaction, transaction: {"selected_transport" => "pickup", "selected_payment" => "cash"}

            check 'transaction_tos_accepted'
            click_button I18n.t 'transaction.actions.purchase'

            current_path.should eq transaction_path transaction
          end

          context "when testing the displayed total price" do
            context "without cash_on_delivery" do
              it "should show the correct price for insured transports" do
                t = FactoryGirl.create :transaction, article: FactoryGirl.create(:article, price: 1000, transport_insured: true, transport_insured_price: 10.99, transport_insured_provider: 'DHL')

                visit edit_transaction_path t, transaction: {"selected_transport" => "insured", "selected_payment" => "cash"}

                page.should_not have_content I18n.t 'transaction.edit.payment_cash_on_delivery_price' # could be put in a separate test
                page.should have_content '1.010,99'
              end

              it "should show the correct price for uninsured transports" do
                t = FactoryGirl.create :transaction, article: FactoryGirl.create(:article, price: 1000, transport_uninsured: true, transport_uninsured_price: 5.99, transport_uninsured_provider: 'DHL')

                visit edit_transaction_path t, transaction: {"selected_transport" => "uninsured", "selected_payment" => "cash"}

                page.should have_content '1.005,99'
              end

              it "should show the correct price for pickups" do
                t = FactoryGirl.create :transaction, article: FactoryGirl.create(:article, price: 999)

                visit edit_transaction_path t, transaction: {"selected_transport" => "pickup", "selected_payment" => "cash"}

                page.should have_content '999'
              end
            end

            context "with cash_on_delivery" do
              it "should display the increased price" do
                t = FactoryGirl.create :transaction, article: FactoryGirl.create(:article, payment_cash_on_delivery: true, payment_cash_on_delivery_price: 7.77, price: 1000, transport_insured: true, transport_insured_price: 10.99, transport_insured_provider: 'DHL')

                visit edit_transaction_path t, transaction: {"selected_transport" => "insured", "selected_payment" => "cash_on_delivery"}

                page.should have_content I18n.t('transaction.edit.payment_cash_on_delivery_price')
                page.should have_content '7,77'
                page.should have_content '1.018,76'
              end
            end
          end

          context "when testing the displayed basic price" do
            it "should show a basic price when one was set" do
              t = FactoryGirl.create :transaction, article: FactoryGirl.create(:article, basic_price: 1111.11)
              visit edit_transaction_path t, transaction: {"selected_transport" => "pickup", "selected_payment" => "cash"}

              page.should have_content I18n.t 'transaction.edit.basic_price'
              page.should have_content '1.111,11'
            end

            it "should not show a basic price when none was set" do
              t = FactoryGirl.create :transaction, article: FactoryGirl.create(:article, :with_private_user, basic_price_cents: 0)
              visit edit_transaction_path t, transaction: {"selected_transport" => "pickup", "selected_payment" => "cash"}

              page.should_not have_content I18n.t 'transaction.edit.basic_price'
            end
          end

          context "when testing the displayed purchase data" do
            it "should show the correct shipping provider for insured transports" do
              t = FactoryGirl.create :transaction, article: FactoryGirl.create(:article, transport_insured: true, transport_insured_price: 10.99, transport_insured_provider: 'Foobar')

              visit edit_transaction_path t, transaction: {"selected_transport" => "insured", "selected_payment" => "cash"}

              page.should have_content I18n.t('transaction.edit.transport_provider')
              page.should have_content 'Foobar'
            end

            it "should show the correct shipping provider for uninsured transports" do
              t = FactoryGirl.create :transaction, article: FactoryGirl.create(:article, transport_uninsured: true, transport_uninsured_price: 5.99, transport_uninsured_provider: 'Bazfuz')

              visit edit_transaction_path t, transaction: {"selected_transport" => "uninsured", "selected_payment" => "cash"}

              page.should have_content I18n.t('transaction.edit.transport_provider')
              page.should have_content 'Bazfuz'
            end

            it "should not display a shipping provider for pickups" do
              visit edit_transaction_path transaction, transaction: {"selected_transport" => "pickup", "selected_payment" => "cash"}

              page.should_not have_content I18n.t('transaction.edit.transport_provider')
            end
          end
        end

        context "given invalid data" do
          it "should not render with an unsupported transport type" do
            visit edit_transaction_path transaction, transaction: {"selected_transport" => "insured", "selected_payment" => "cash"}

            page.should_not have_button I18n.t 'transaction.actions.purchase'
            page.should have_content I18n.t 'transaction.notices.transport_not_supported'
          end

          it "should not render with an unsupported payment type" do
            visit edit_transaction_path transaction, transaction: {"selected_transport" => "pickup", "selected_payment" => "paypal"}

            page.should_not have_button I18n.t 'transaction.actions.purchase'
            page.should have_content I18n.t 'transaction.notices.payment_not_supported'
          end
        end
      end
    end

    context "for a logged-out user" do
      it "should not yet be accessible" do
        visit edit_transaction_path transaction
        current_path.should eq new_user_session_path
      end
    end
  end

  describe "#show" do
    context "for a logged-in user" do
      context "when the transaction is sold" do
        let (:transaction) { FactoryGirl.create :sold_transaction }

        it "should not redirect" do
          login_as transaction.buyer
          visit transaction_path transaction
          current_path.should eq transaction_path transaction
        end
      end
    end

    context "for a logged-out user" do
      it "should not yet be accessible" do
        visit edit_transaction_path transaction
        current_path.should eq new_user_session_path
      end
    end
  end
end
