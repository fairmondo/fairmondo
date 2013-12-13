require "spec_helper"
include Warden::Test::Helpers
include FastBillStubber

describe Discount do
  before do
    stub_fastbill
  end

  let( :user ) { FactoryGirl.create :user }
  let( :transaction ) { FactoryGirl.create :single_transaction }
  let( :discount ) { FactoryGirl.create :discount }

  describe 'when creating an article and an discount is active' do
    it 'it should be applied to article' do
      discount
      article = FactoryGirl.create :article
      article.discount_id.should eq discount.id
    end
  end

  describe 'when buying an article' do
    before do
      login_as user
    end

    it 'should apply discount', visible: true do
      discount
      article = FactoryGirl.create :article
      visit transaction_path( article.transaction )
      save_and_open_page
      click_button 'Weiter'
      click_button I18n.t('transaction.actions.purchase')
      FastbillAPI.should receive( :fastbill_discount )
    end
  end
end
