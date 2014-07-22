require_relative '../test_helper'

include Warden::Test::Helpers
include FastBillStubber

feature 'Discounts' do
  let( :user ) { FactoryGirl.create :user }
  let( :discount ) { FactoryGirl.create :discount }
  let( :article ){ FactoryGirl.create :article, seller: FactoryGirl.create( :private_user ), discount: discount }

  before do
    login_as user
  end

  scenario 'user buys an Article with discount' do
    visit business_transaction_path( article.business_transaction )
    click_button I18n.t('common.actions.continue')
    FastbillAPI.expects( :fastbill_discount )
    click_button I18n.t('transaction.actions.purchase')
  end
end
