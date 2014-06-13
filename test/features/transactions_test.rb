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
require 'test_helper'
include Warden::Test::Helpers

describe 'BusinessTransaction' do

  let(:business_transaction) { FactoryGirl.create :single_transaction }
  let(:article) { business_transaction.article }
  let(:seller) { business_transaction.article.seller }
  let(:user) { FactoryGirl.create :user }
  let(:private_transaction) {FactoryGirl.create :single_transaction, :private_transaction}
  let(:legal_transaction) {FactoryGirl.create :single_transaction, :legal_transaction}

  describe "#edit" do

    context "for a logged-in user" do
      before { login_as user }

      describe "during step 1" do
        it "should show the correct data and fields" do
          visit edit_business_transaction_path business_transaction

          page.should have_content I18n.t 'transaction.edit.heading'

          # Should display article data
          page.should have_link article.title
          page.should have_link seller.nickname
          page.should have_content I18n.t 'transaction.edit.preliminary_price'

          # Should display purchase options
          page.should have_content I18n.t 'transaction.edit.choose_purchase_data'
          ## Should display shipping selection
          page.should have_content I18n.t 'formtastic.labels.business_transaction.selected_transport'
          page.should have_selector 'select', text: I18n.t('enumerize.business_transaction.selected_transport.pickup')
          ## Should display payment selection
          page.should have_content I18n.t 'formtastic.labels.business_transaction.selected_payment'
          page.should have_selector 'select', text: I18n.t('enumerize.business_transaction.selected_payment.cash')
          ## Should display buyer's address
          page.should have_content I18n.t 'transaction.edit.address'
          page.should have_css "input#business_transaction_forename[@value='#{user.forename}']"
          page.should have_css "input#business_transaction_surname[@value='#{user.surname}']"
          page.should have_css "input#business_transaction_address_suffix[@value='#{user.address_suffix}']"
          page.should have_css "input#business_transaction_street[@value='#{user.street}']"
          page.should have_css "input#business_transaction_city[@value='#{user.city}']"
          page.should have_css "input#business_transaction_zip[@value='#{user.zip}']"
          page.should have_selector 'select', text: user.country

          # Should display info text and button
          page.should have_content I18n.t 'transaction.edit.next_step_explanation'
          page.should have_button I18n.t 'common.actions.continue'
        end

        it "should show a quantity field for MultipleFixedPriceTransactions" do
          visit edit_business_transaction_path FactoryGirl.create :multiple_transaction

          page.should have_content I18n.t('formtastic.labels.business_transaction.quantity_bought')
        end

        it "shouldn't show a quantity field for other transactions" do
          visit edit_business_transaction_path business_transaction

          page.should_not have_content I18n.t('formtastic.labels.business_transaction.quantity_bought')
        end

        it "should lead to step 2" do
          visit edit_business_transaction_path business_transaction

          page.should_not have_button I18n.t 'transaction.actions.purchase'
          click_button I18n.t 'common.actions.continue'

          page.should have_button I18n.t 'transaction.actions.purchase'
        end
      end

      describe "during step 2" do
        context "given valid data" do
          it "should have the correct fields and texts" do
            visit edit_business_transaction_path business_transaction
            click_button I18n.t 'common.actions.continue'

            # Should have pre-filled hidden fields
            page.should have_css 'input#business_transaction_quantity_bought[@type=hidden][@value="1"]'
            page.should have_css 'input#business_transaction_selected_transport[@type=hidden][@value=pickup]'
            page.should have_css 'input#business_transaction_selected_payment[@type=hidden][@value=cash]'

            # Should display article data
            page.should have_link article.title
            page.should have_link seller.nickname
            page.should have_content I18n.t 'transaction.edit.preliminary_price'

            # Should display chosen quantity
            page.should have_content(I18n.t('transaction.edit.quantity_bought')+' 1')

            # Should display chosen payment type
            page.should have_content I18n.t 'transaction.edit.payment_type'
            page.should have_content I18n.t 'enumerize.business_transaction.selected_payment.cash'

            # Should display chosen transport type (specs for transport provider further down)
            page.should have_content I18n.t 'transaction.edit.transport_type'
            page.should have_content I18n.t 'enumerize.business_transaction.selected_transport.pickup'

            # Should display buyer's address
            page.should have_content I18n.t 'transaction.edit.address'
            page.should have_content user.fullname
            page.should have_content user.street
            page.should have_content user.address_suffix
            page.should have_content user.zip
            page.should have_content user.city
            page.should have_content user.country

            # Should have optional message field
            page.should have_content I18n.t 'transaction.edit.message'

            # Should display buttons
            page.should have_link I18n.t 'common.actions.back'
            page.should have_button I18n.t 'transaction.actions.purchase'
          end

          context "dependent on kind of seller (legal vs private)" do
            it "should show imprint, terms, declaration of invocation and terms-checkbox if seller is legal entity" do
              visit edit_business_transaction_path legal_transaction
              click_button I18n.t 'common.actions.continue'

              # Should display imprint
              page.should have_content I18n.t 'transaction.edit.imprint'
              page.should have_content legal_transaction.article_seller.about

              # Should display terms
              page.should have_content I18n.t 'transaction.edit.terms'
              page.should have_content legal_transaction.article_seller.terms

              # Should display declaration of revocation
              page.should have_content I18n.t 'transaction.edit.cancellation'
              page.should have_content legal_transaction.article_seller.cancellation

              # Should display a checkbox for the terms
              page.should have_css 'input#business_transaction_tos_accepted[@type=checkbox]'
            end

            it "should not show imprint, terms, declaration of invocation and terms-checkbox" do
              visit edit_business_transaction_path private_transaction
              click_button I18n.t 'common.actions.continue'

              page.should_not have_css('div.about_terms_cancellation')
            end
          end

          it "should have working terms 'print' link that leads to a new page with only the print view (and auto-executing js)" do
            visit edit_business_transaction_path legal_transaction
            click_button I18n.t 'common.actions.continue'
            within '#terms' do
              click_link 'Drucken'
            end
            page.should have_content legal_transaction.article_seller_terms
          end

          it "should have a working cancellation 'print' link ..." do
            visit edit_business_transaction_path legal_transaction
            click_button I18n.t 'common.actions.continue'
            within '#cancellation' do
              click_link 'Drucken'
            end
            page.should have_content legal_transaction.article_seller_cancellation
          end

          it "should submit the data successfully with accepted terms" do
            FastbillAPI.stub(:fastbill_chain)

            visit edit_business_transaction_path legal_transaction
            click_button I18n.t 'common.actions.continue'

            check 'business_transaction_tos_accepted'
            click_button I18n.t 'transaction.actions.purchase'

            current_path.should eq business_transaction_path legal_transaction
          end

          it "should not submit the data successfully without accepted terms" do
            visit edit_business_transaction_path legal_transaction

            click_button I18n.t 'common.actions.continue'

            click_button I18n.t 'transaction.actions.purchase'

            page.should have_css 'input#business_transaction_tos_accepted[@type=checkbox]' # is still on step 2
            page.should have_content I18n.t 'errors.messages.accepted'
          end

          context "when testing the effects of the purchase" do
            before do
              FastbillAPI.stub(:fastbill_chain)
            end
            context "for SingleFixedPriceTransaction" do
              it "should set the states of article and transaction" do
                visit edit_business_transaction_path business_transaction
                click_button I18n.t 'common.actions.continue'

                business_transaction.should be_available
                business_transaction.article.should be_active

                if business_transaction.article_seller.is_a? LegalEntity
                  check 'business_transaction_tos_accepted'
                end
                click_button I18n.t 'transaction.actions.purchase'

                business_transaction.reload.should be_sold
                business_transaction.article.should be_sold
              end

              describe "on search", search: true do
                it "should remove the article from the search result list" do
                  business_transaction = FactoryGirl.create :single_transaction, article: FactoryGirl.create(:article, title: 'foobar')
                  Article.index.refresh
                  visit articles_path
                  page.should have_link 'foobar'

                  visit edit_business_transaction_path business_transaction
                  click_button I18n.t 'common.actions.continue'
                  if business_transaction.article_seller.is_a? LegalEntity
                    check 'business_transaction_tos_accepted'
                  end
                  click_button I18n.t 'transaction.actions.purchase'
                  Article.index.refresh
                  visit articles_path
                  page.should_not have_link 'foobar'
                end
              end

              it "should show an error page when article was already sold to someone else in the meantime" do
                visit edit_business_transaction_path business_transaction
                click_button I18n.t 'common.actions.continue'

                if business_transaction.article_seller.is_a? LegalEntity
                  check 'business_transaction_tos_accepted'
                end

                mail = Mail::Message.new
                BusinessTransactionMailer.stub(:seller_notification).and_return(mail)
                BusinessTransactionMailer.stub(:buyer_notification).and_return(mail)
                mail.stub(:deliver)
                business_transaction.update_attribute :state, 'sold'

                click_button I18n.t 'transaction.actions.purchase'
                page.should have_content 'bereits verkauft.'
              end
            end

            context "for MultipleFixedPriceTransactions" do
              let(:article) { FactoryGirl.create :article, :with_larger_quantity }
              let(:business_transaction) { article.business_transaction }

              it "should reduce the number of items" do
                visit edit_business_transaction_path business_transaction
                click_button I18n.t 'common.actions.continue'
                if business_transaction.article_seller.is_a? LegalEntity
                  check 'business_transaction_tos_accepted'
                end
                click_button I18n.t 'transaction.actions.purchase'

                visit article_path business_transaction.article
                page.should have_content I18n.t('formtastic.labels.article.quantity_with_numbers', quantities: (business_transaction.article_quantity - 1))
              end

              describe "on search", search: true do
                it "should set the article to 'sold out' when all items are sold" do
                  visit edit_business_transaction_path business_transaction
                  fill_in 'business_transaction_quantity_bought', with: business_transaction.quantity_available
                  click_button I18n.t 'common.actions.continue'
                  if business_transaction.article_seller.is_a? LegalEntity
                    check 'business_transaction_tos_accepted'
                  end
                  click_button I18n.t 'transaction.actions.purchase'
                  Article.index.refresh
                  article.reload.should be_sold
                  visit articles_path
                  page.should_not have_content Regexp.new article.title[0..20]
                end
              end
            end

            context "for all business_transactions" do
              it "should send an email to the buyer" do
                business_transaction = FactoryGirl.create :single_transaction, :buyer => user
                visit edit_business_transaction_path business_transaction
                click_button I18n.t 'common.actions.continue'
                if business_transaction.article_seller.is_a? LegalEntity
                  check 'business_transaction_tos_accepted'
                end
                click_button I18n.t 'transaction.actions.purchase'

                ActionMailer::Base.deliveries.last.to.should == [business_transaction.buyer_email]
                #ActionMailer::Base.deliveries.last.encoded.should include( I18n.t('transaction.notifications.buyer.buyer_text') )
              end

              it "should send a email to the seller" do
                business_transaction = FactoryGirl.create :single_transaction, :buyer => user
                visit edit_business_transaction_path business_transaction
                click_button I18n.t 'common.actions.continue'
                if business_transaction.article_seller.is_a? LegalEntity
                  check 'business_transaction_tos_accepted'
                end
                click_button I18n.t 'transaction.actions.purchase'

                ActionMailer::Base.deliveries[-2].to.should == [business_transaction.article_seller.email]
                #ActionMailer::Base.deliveries[-2].encoded.should include( I18n.t('transaction.notifications.seller.seller_text') )
              end
            end
          end

          context "when testing the displayed total price" do
            context "without cash_on_delivery" do
              context "for SingleFixedPriceTransactions" do
                it "should show the correct price for type1 transports" do
                  t = FactoryGirl.create :single_transaction, article: FactoryGirl.create(:article, payment_invoice: true, price: 1000, transport_type1: true, transport_type1_price: '10,99', transport_type1_provider: 'DHL')

                  visit edit_business_transaction_path t
                  select I18n.t 'enumerize.business_transaction.selected_transport.type1', from: 'business_transaction_selected_transport'
                  select I18n.t 'enumerize.business_transaction.selected_payment.invoice', from: 'business_transaction_selected_payment'
                  click_button I18n.t 'common.actions.continue'

                  page.should_not have_content I18n.t 'transaction.edit.payment_cash_on_delivery_price' # could be put in a separate test
                  page.should have_content '1.010,99'
                end

                it "should show the correct price for type2 transports" do
                  t = FactoryGirl.create :single_transaction, article: FactoryGirl.create(:article, payment_invoice: true, price: 1000, transport_type2: true, transport_type2_price: '5,99', transport_type2_provider: 'DHL')

                  visit edit_business_transaction_path t
                  select I18n.t 'enumerize.business_transaction.selected_transport.type2', from: 'business_transaction_selected_transport'
                  select I18n.t 'enumerize.business_transaction.selected_payment.invoice', from: 'business_transaction_selected_payment'
                  click_button I18n.t 'common.actions.continue'

                  page.should have_content '1.005,99'
                end

                it "should show the correct price for pickups" do
                  t = FactoryGirl.create :single_transaction, article: FactoryGirl.create(:article, price: 999)

                  visit edit_business_transaction_path t
                  select I18n.t 'enumerize.business_transaction.selected_transport.pickup', from: 'business_transaction_selected_transport'
                  click_button I18n.t 'common.actions.continue'

                  page.should have_content '999'
                end
              end

              context "for MultipleFixedPriceTransactions" do
                describe "when quantity_bought is greater than one" do
                  it "should show the correct price when no transport or payment costs extra" do
                    t = FactoryGirl.create :multiple_transaction, article: FactoryGirl.create(:article, :with_larger_quantity, price: 222)

                    visit edit_business_transaction_path t
                    fill_in 'business_transaction_quantity_bought', with: 2
                    click_button I18n.t 'common.actions.continue'

                    page.should have_content '444'
                  end

                  # ... Put the rest in helper specs
                end
              end
            end

            context "with cash_on_delivery" do
              it "should display the increased price" do
                t = FactoryGirl.create :business_transaction, article: FactoryGirl.create(:article, payment_cash_on_delivery: true, payment_cash_on_delivery_price: '7,77', price: 1000, transport_type1: true, transport_type1_price: '10,99', transport_type1_provider: 'DHL')

                visit edit_business_transaction_path t
                select I18n.t 'enumerize.business_transaction.selected_transport.type1', from: 'business_transaction_selected_transport'
                select I18n.t 'enumerize.business_transaction.selected_payment.cash_on_delivery', from: 'business_transaction_selected_payment'
                click_button I18n.t 'common.actions.continue'

                page.should have_content I18n.t('transaction.edit.payment_cash_on_delivery_price')
                page.should have_content '7,77'
                page.should have_content '1.018,76'
              end
            end
          end

          context "when testing the displayed basic price" do
            it "should show a basic price when one was set" do
              t = FactoryGirl.create :business_transaction, article: FactoryGirl.create(:article, basic_price: '1111,11', seller: FactoryGirl.create(:legal_entity))
              visit edit_business_transaction_path t
              click_button I18n.t 'common.actions.continue'

              page.should have_content I18n.t 'transaction.edit.basic_price'
              page.should have_content '1.111,11'
            end

            it "should not show a basic price when none was set" do
              t = FactoryGirl.create :business_transaction, article: FactoryGirl.create(:article, :with_private_user, basic_price_cents: 0, seller: FactoryGirl.create(:legal_entity))
              visit edit_business_transaction_path t
              click_button I18n.t 'common.actions.continue'

              page.should_not have_content I18n.t 'transaction.edit.basic_price'
            end
          end

          context "when testing the displayed purchase data" do
            it "should show the correct shipping provider for type1 transports" do
              t = FactoryGirl.create :business_transaction, article: FactoryGirl.create(:article, payment_invoice: true, transport_type1: true, transport_type1_price: '10,99', transport_type1_provider: 'Foobar')

              visit edit_business_transaction_path t
              select I18n.t 'enumerize.business_transaction.selected_transport.type1', from: 'business_transaction_selected_transport'
              select I18n.t 'enumerize.business_transaction.selected_payment.invoice', from: 'business_transaction_selected_payment'
              click_button I18n.t 'common.actions.continue'

              page.should have_content I18n.t('transaction.edit.transport_provider')
              page.should have_content 'Foobar'
            end

            it "should show the correct shipping provider for type2 transports" do
              t = FactoryGirl.create :business_transaction, article: FactoryGirl.create(:article, payment_invoice: true, transport_type2: true, transport_type2_price: '5,99', transport_type2_provider: 'Bazfuz')

              visit edit_business_transaction_path t
              select I18n.t 'enumerize.business_transaction.selected_transport.type2', from: 'business_transaction_selected_transport'
              select I18n.t 'enumerize.business_transaction.selected_payment.invoice', from: 'business_transaction_selected_payment'
              click_button I18n.t 'common.actions.continue'

              page.should have_content I18n.t('transaction.edit.transport_provider')
              page.should have_content 'Bazfuz'
            end

            it "should not display a shipping provider for pickups" do
              visit edit_business_transaction_path business_transaction
              click_button I18n.t 'common.actions.continue'

              page.should_not have_content I18n.t('transaction.edit.transport_provider')
            end
          end
        end

        context "given invalid data" do


          it "should not render with invalid address fields" do
            visit edit_business_transaction_path business_transaction
            fill_in 'business_transaction_forename', with: ''
            fill_in 'business_transaction_surname', with: ''
            fill_in 'business_transaction_street', with: 'foobar' # no number
            fill_in 'business_transaction_city', with: ''
            fill_in 'business_transaction_zip', with: 'abc'
            click_button I18n.t 'common.actions.continue'

            page.should_not have_button I18n.t 'transaction.actions.purchase'
            within '#business_transaction_forename_input' do
              page.should have_content I18n.t 'errors.messages.blank'
            end
            within '#business_transaction_surname_input' do
              page.should have_content I18n.t 'errors.messages.blank'
            end
            within '#business_transaction_street_input' do
              page.should have_content I18n.t 'errors.messages.invalid'
            end
            within '#business_transaction_city_input' do
              page.should have_content I18n.t 'errors.messages.blank'
            end
            within '#business_transaction_zip_input' do
              page.should have_content I18n.t 'errors.messages.zip_format'
            end
          end

          it "should not render with a quantity that's too high" do
            mfpt = FactoryGirl.create(:multiple_transaction)
            visit edit_business_transaction_path mfpt
            fill_in 'business_transaction_quantity_bought', with: '9999999'
            click_button I18n.t 'common.actions.continue'

            within '#business_transaction_quantity_bought_input' do
              page.should have_content I18n.t('transaction.errors.too_many_bought', available: mfpt.quantity_available)
            end
          end
        end
      end
    end

    context "for a logged-out user" do
      it "should not yet be accessible" do
        visit edit_business_transaction_path business_transaction
        current_path.should eq new_user_session_path
      end
    end
  end

  describe "#show" do
    context "for a logged-in user" do
      context "when the business_transaction is sold" do
        let(:business_transaction) { FactoryGirl.create :single_transaction, :sold }
        let(:buyer)       { business_transaction.buyer }
        let(:seller)      { business_transaction.seller }


        context "and the user is the buyer" do
          before do
            login_as buyer
            visit business_transaction_path business_transaction
          end

          it "should not redirect" do
            current_path.should eq business_transaction_path business_transaction
          end

          it "should show the correct data and fields" do
            pending "Not yet implemented."
            page.should have_content "Alles moegliche"
          end

          it "should have links to article and user profile" do
            page.should have_link business_transaction.article.title
            page.should have_link business_transaction.article_seller_nickname
          end

          it "should be possible to see the printed version of the order details" do
            click_link I18n.t("transaction.actions.print_order.buyer")
            page.should have_content I18n.t('transaction.notifications.buyer.buyer_text')
          end

        end

        context "but the current user isn't the one who bought" do
          it "shouldn't be accessible" do
            login_as user
            expect do
              visit business_transaction_path business_transaction
            end.to raise_error(Pundit::NotAuthorizedError)
          end
        end
      end

      context "when the business_transaction is not sold" do
        it "should redirect to the edit page" do
          login_as user
          visit business_transaction_path business_transaction
          current_path.should eq edit_business_transaction_path business_transaction
        end
      end

      context "but the business_transaction is a MFPT" do
        it "should redirect the user to the business_transaction#show of the business_transaction he bought" do
          t = FactoryGirl.create :partial_transaction
          login_as t.buyer

          visit business_transaction_path t.parent
          current_path.should eq business_transaction_path t
        end
      end
    end

    context "for a logged-out user" do
      it "should not yet be accessible" do
        visit edit_business_transaction_path business_transaction
        current_path.should eq new_user_session_path
      end
    end
  end
end
