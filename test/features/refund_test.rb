require_relative '../test_helper'
include FastBillStubber
include Warden::Test::Helpers

feature "Refunds" do

  def do_refund
    click_link I18n.t( 'refund.button' )
    page.must_have_content( I18n.t( 'refund.heading' ) )
    page.must_have_content( I18n.t( 'formtastic.labels.refund.reason' ) )
    page.must_have_content( I18n.t( 'formtastic.labels.refund.description' ) )
    page.must_have_selector( '#refund_reason' )
    page.must_have_selector( '#refund_description' )
    page.must_have_button( I18n.t( 'common.actions.send' ) )
    fill_in 'refund_description', :with => 'a' * 160
    click_button I18n.t( 'common.actions.send' )
    page.must_have_content(I18n.t('flash.refunds.create.notice' ))
  end

  scenario 'legal entity does a refund after 44 days' do
    seller = FactoryGirl.create :legal_entity
    login_as seller
    transaction = FactoryGirl.create :business_transaction, :older, seller: seller
    visit user_path( seller )
    do_refund
  end

  scenario 'private user does a refund after 27 days' do
    seller = FactoryGirl.create :private_user
    login_as seller
    transaction = FactoryGirl.create :business_transaction, :old, seller: seller
    visit user_path( seller )
    do_refund
  end
end
