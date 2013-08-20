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

  def pay_on_pickup_attrs
    { transaction: {"selected_transport" => "pickup", "selected_payment" => "cash"} }
  end

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

          # Should have optional message field
          page.should have_content I18n.t('formtastic.labels.transaction.message')
        end

        it "should show a quantity field for MultipleFixedPriceTransactions" do
          pending "Not yet implemented."
        end

        it "shouldn't show a quantity field for other transactions" do
          pending "Not yet implemented."
        end

        it "should have working 'print' links that lead to a new page with only the print view (and auto-executing js)" do
          pending "Not yet implemented."
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

          it "should submit the data successfully with accepted AGB" do
            visit edit_transaction_path transaction, transaction: {"selected_transport" => "pickup", "selected_payment" => "cash"}

            check 'transaction_tos_accepted'
            click_button I18n.t 'transaction.actions.purchase'

            current_path.should eq transaction_path transaction
          end

          it "should not submit the data successfully without accepted AGB" do
            visit edit_transaction_path transaction, transaction: {"selected_transport" => "pickup", "selected_payment" => "cash"}

            click_button I18n.t 'transaction.actions.purchase'

            page.should have_css 'input#transaction_tos_accepted[@type=checkbox]' # is still on step 2
            page.should have_content I18n.t 'activerecord.attributes.transaction.tos_accepted'
          end

          context "when testing the effects of the purchase" do
            context "for FixedPriceTransactions" do
              let (:transaction) { FactoryGirl.create :single_transaction }
              it "should set the states of article and transaction" do
                visit edit_transaction_path transaction, pay_on_pickup_attrs

                transaction.should be_available
                transaction.article.should be_active

                check 'transaction_tos_accepted'
                click_button I18n.t 'transaction.actions.purchase'

                transaction.reload.should be_sold
                transaction.article.should be_closed
              end

              describe "on search", search: true do
                it "should remove the article from the search result list" do
                  transaction = FactoryGirl.create :single_transaction, article: FactoryGirl.create(:article, title: 'foobar')
                  Sunspot.commit

                  visit articles_path
                  page.should have_link 'foobar'

                  visit edit_transaction_path transaction, pay_on_pickup_attrs
                  check 'transaction_tos_accepted'
                  click_button I18n.t 'transaction.actions.purchase'

                  visit articles_path
                  page.should_not have_link 'foobar'
                end
              end

              it "should show an error page when article was already sold to someone else in the meantime" do
                pending "Not yet implemented."
                visit edit_transaction_path transaction, pay_on_pickup_attrs
                check 'transaction_tos_accepted'

                transaction.sell

                click_button I18n.t 'transaction.actions.purchase'
                page.should have_content 'Bereits verkauft.'
              end
            end

            context "for MultipleFixedPriceTransactions" do
              it "should reduce the number of items by one or more (depending on user choice)" do
                pending "Not yet implemented."
              end
            end

            context "for all transactions" do
              it "should send an email to the buyer" do
                transaction = FactoryGirl.create :single_transaction
                visit edit_transaction_path transaction, pay_on_pickup_attrs
                check 'transaction_tos_accepted'
                click_button I18n.t 'transaction.actions.purchase'

                ActionMailer::Base.deliveries.last.encoded.should include("Erfolgreich gekauft... Zahlungsdaten und so")
              end

              it "should send a email to the seller" do
                transaction = FactoryGirl.create :single_transaction
                visit edit_transaction_path transaction, pay_on_pickup_attrs
                check 'transaction_tos_accepted'
                click_button I18n.t 'transaction.actions.purchase'

                ActionMailer::Base.deliveries[-2].encoded.should include("Artikel verkauft... Artikeldaten, Adressdaten und so")
              end
            end
          end

          context "when testing the displayed total price" do
            context "without cash_on_delivery" do
              it "should show the correct price for type1 transports" do
                t = FactoryGirl.create :transaction, article: FactoryGirl.create(:article, price: 1000, transport_type1: true, transport_type1_price: 10.99, transport_type1_provider: 'DHL')

                visit edit_transaction_path t, transaction: {"selected_transport" => "type1", "selected_payment" => "cash"}

                page.should_not have_content I18n.t 'transaction.edit.payment_cash_on_delivery_price' # could be put in a separate test
                page.should have_content '1.010,99'
              end

              it "should show the correct price for type2 transports" do
                t = FactoryGirl.create :transaction, article: FactoryGirl.create(:article, price: 1000, transport_type2: true, transport_type2_price: 5.99, transport_type2_provider: 'DHL')

                visit edit_transaction_path t, transaction: {"selected_transport" => "type2", "selected_payment" => "cash"}

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
                t = FactoryGirl.create :transaction, article: FactoryGirl.create(:article, payment_cash_on_delivery: true, payment_cash_on_delivery_price: 7.77, price: 1000, transport_type1: true, transport_type1_price: 10.99, transport_type1_provider: 'DHL')

                visit edit_transaction_path t, transaction: {"selected_transport" => "type1", "selected_payment" => "cash_on_delivery"}

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
            it "should show the correct shipping provider for type1 transports" do
              t = FactoryGirl.create :transaction, article: FactoryGirl.create(:article, transport_type1: true, transport_type1_price: 10.99, transport_type1_provider: 'Foobar')

              visit edit_transaction_path t, transaction: {"selected_transport" => "type1", "selected_payment" => "cash"}

              page.should have_content I18n.t('transaction.edit.transport_provider')
              page.should have_content 'Foobar'
            end

            it "should show the correct shipping provider for type2 transports" do
              t = FactoryGirl.create :transaction, article: FactoryGirl.create(:article, transport_type2: true, transport_type2_price: 5.99, transport_type2_provider: 'Bazfuz')

              visit edit_transaction_path t, transaction: {"selected_transport" => "type2", "selected_payment" => "cash"}

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
            visit edit_transaction_path transaction, transaction: {"selected_transport" => "type1", "selected_payment" => "cash"}

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
        let (:buyer)       { transaction.buyer }

        context "and the user is the buyer" do
          before do
            login_as buyer
            visit transaction_path transaction
          end

          it "should not redirect" do
            current_path.should eq transaction_path transaction
          end

          it "should show the correct data and fields" do
            pending "Not yet implemented."
            page.should have_content "Alles moegliche"
          end
        end

        context "but the current user isn't the one who bought" do
          it "shouldn't be accessible" do
            pending "Not yet implemented."
            login_as user
            visit transaction_path transaction
            current_path.should_not eq transaction_path transaction
            page.should have_content "What are you trying to do there buddy?"
          end
        end
      end

      context "when the transaction is not sold" do
        it "should redirect to the edit page" do
          pending "Not yet implemented."
          login_as user
          visit transaction_path transaction
          current_path.should eq edit_transaction_path transaction
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
