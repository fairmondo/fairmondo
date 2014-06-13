require "test_helper"
include Warden::Test::Helpers
include FastBillStubber

describe Discount do
  before do
    stub_fastbill
  end

  let( :user ) { FactoryGirl.create :user }
  let( :discount ) { FactoryGirl.create :discount }
  let( :article ){ FactoryGirl.create :article, seller: FactoryGirl.create( :private_user ), discount: discount }

  describe 'when creating an article and an discount is active' do
    it 'it should be applied to article' do
      article.discount_id.should eq discount.id
    end
  end

  describe 'when buying an article' do
    before do
      login_as user
    end

    it 'should apply discount' do
      visit business_transaction_path( article.business_transaction )
      click_button I18n.t('common.actions.continue')
      FastbillAPI.should receive( :fastbill_discount )
      click_button I18n.t('transaction.actions.purchase')
    end
  end
end
