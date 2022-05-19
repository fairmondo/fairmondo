#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class AfterTransationRefundTest < ApplicationSystemTestCase
  def do_refund
    click_link I18n.t('refund.button')
    assert page.has_content?(I18n.t('refund.heading'))
    assert page.has_content?(I18n.t('formtastic.labels.refund.reason'))
    assert page.has_content?(I18n.t('formtastic.labels.refund.description'))
    fill_in 'refund_description', with: 'a' * 160
    click_button I18n.t('common.actions.send')
    assert page.has_content?(I18n.t('flash.refunds.create.notice'))
  end

  test 'legal entity does a refund after 44 days' do
    seller = create :legal_entity, :paypal_data
    sign_in seller
    transaction = create :business_transaction, :older, seller: seller
    visit line_item_group_path(transaction.line_item_group, tab: :payments)
    do_refund
  end

  test 'private user does a refund after 27 days' do
    seller = create :private_user, :paypal_data
    sign_in seller
    transaction = create :business_transaction, :old, seller: seller
    visit line_item_group_path(transaction.line_item_group, tab: :payments)
    do_refund
  end
end
