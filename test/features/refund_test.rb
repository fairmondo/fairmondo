require 'test_helper'
include FastBillStubber
include Warden::Test::Helpers

describe Refund do
  let( :luser ){ FactoryGirl.create :private_user }
  let( :puser ){ FactoryGirl.create :legal_entity}
  let( :particle ){ FactoryGirl.create :article, :without_build_business_transaction, :with_all_transports, state: 'sold', seller: puser }
  let( :larticle ){ FactoryGirl.create :article, :without_build_business_transaction, :with_all_transports, state: 'sold', seller: luser }
  let( :ptransaction ){ FactoryGirl.create :business_transaction_with_buyer, :old, article: particle, seller: puser }
  let( :ltransaction ){ FactoryGirl.create :business_transaction_with_buyer, :old, article: larticle, seller: luser }

  before do
    stub_fastbill
  end

  context 'logged in user' do
    context 'LegalEntity' do
      before { login_as( luser ) }
      context 'is transaction seller and time is between 14 and 45 days after transaction was set to sold' do
        it 'transaction item view on user page should show refund button' do
          ltransaction
          visit user_path( luser )
          page.should have_selector( :link_or_button, I18n.t( 'refund.button' ) )
        end

        it 'should show right elements' do
          visit new_business_transaction_refund_path( ltransaction )
          page.should have_content( I18n.t( 'refund.heading' ) )
          page.should have_content( I18n.t( 'formtastic.labels.refund.reason' ) )
          page.should have_content( I18n.t( 'formtastic.labels.refund.description' ) )
          page.should have_selector( '#refund_reason' )
          page.should have_selector( '#refund_description' )
          page.should have_button( I18n.t( 'common.actions.send' ) )
        end

        it 'should create new refund' do
          visit new_business_transaction_refund_path( ltransaction )
          fill_in 'refund_description', :with => 'a' * 160
          click_button I18n.t( 'common.actions.send' )
          page.should have_content(I18n.t('flash.refunds.create.notice' ))
        end
      end
    end

    context 'PrivateUser' do
      before { login_as( puser ) }
      context 'is transaction seller and time is between 14 and 28 days after transaction was set to sold' do
        it 'transaction item view on user page should show refund button' do
          ptransaction
          visit user_path( puser )
          page.should have_selector( :link_or_button, I18n.t( 'refund.button' ) )
        end

        it 'should show refund_request page' do
          visit new_business_transaction_refund_path( ptransaction )
          page.should have_content( I18n.t( 'refund.heading' ) )
          page.should have_content( I18n.t( 'formtastic.labels.refund.reason' ) )
          page.should have_content( I18n.t( 'formtastic.labels.refund.description' ) )
          page.should have_selector( '#refund_reason' )
          page.should have_selector( '#refund_description' )
          page.should have_button( I18n.t( 'common.actions.send' ) )
        end

        it 'should create new refund' do
          visit new_business_transaction_refund_path( ptransaction )
          fill_in 'refund_description', :with => 'a' * 160
          click_button I18n.t( 'common.actions.send' )
          page.should have_content(I18n.t('flash.refunds.create.notice' ))
        end
      end
    end
  end

  context 'visitor' do
    it 'should not show request refund page' do
      visit new_business_transaction_refund_path( ltransaction )
      page.should_not have_content( I18n.t( 'refund.heading' ) )
      page.should_not have_content( I18n.t( 'formtastic.labels.refund.reason' ) )
      page.should_not have_content( I18n.t( 'formtastic.labels.refund.description' ) )
      page.should_not have_selector( '#refund_reason' )
      page.should_not have_selector( '#refund_description' )
      page.should_not have_button( I18n.t( 'common.actions.send' ) )
    end
  end
end
