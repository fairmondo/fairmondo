require 'spec_helper'
include FastBillStubber
include Warden::Test::Helpers

describe Refund do
  let( :user ){ FactoryGirl.create :user }
  let( :transaction ){ FactoryGirl.create :transaction_with_buyer, :old, seller: user }

  context 'logged in user' do
    before { login_as user }

    context 'LegalEntity' do
      context 'is transaction seller and time is between 14 and 45 days after transaction was set to sold' do
        it 'transaction item vie on user page should show refund button' do
          visit user_path( user )
          page.should have_button( I18n.t( 'invoice.refund_button' ) )
        end
        
        it 'should show right elements' do
          visit new_transaction_refund_path( transaction )
          page.should have_content( I18n.t( 'refund.heading' ) )
          page.should have_content( I18n.t( 'formtastic.labels.refund.reason' ) )
          page.should have_content( I18n.t( 'formtastic.labels.refund.description' ) )
          page.should have_selector( '#refund_reason' )
          page.should have_selector( '#refund_description' )
          page.should have_button( I18n.t( 'common.actions.send' ) )
        end
      end
    end

    context 'PrivateUser' do
      context 'is transaction seller and time is between 14 and 28 days after transaction was set to sold' do
        it 'transaction item vie on user page should show refund button' do
          visit user_path( user )
          page.should have_button( I18n.t( 'invoice.refund_button' ) )
        end
        
        it 'should show refund_request page' do
          visit new_transaction_refund_path( transaction )
          page.should have_content( I18n.t( 'refund.heading' ) )
          page.should have_content( I18n.t( 'formtastic.labels.refund.reason' ) )
          page.should have_content( I18n.t( 'formtastic.labels.refund.description' ) )
          page.should have_selector( '#refund_reason' )
          page.should have_selector( '#refund_description' )
          page.should have_button( I18n.t( 'common.actions.send' ) )
        end
      end
    end
  end

  context 'visitor' do
    it 'should not show request refund page' do
      visit new_transaction_refund_path( transaction )
      page.should_not have_content( I18n.t( 'refund.heading' ) )
      page.should_not have_content( I18n.t( 'formtastic.labels.refund.reason' ) )
      page.should_not have_content( I18n.t( 'formtastic.labels.refund.description' ) )
      page.should_not have_selector( '#refund_reason' )
      page.should_not have_selector( '#refund_description' )
      page.should_not have_button( I18n.t( 'common.actions.send' ) )
    end
  end
end
