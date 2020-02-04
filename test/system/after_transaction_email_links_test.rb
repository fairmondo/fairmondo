#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class AfterTransationEmailLinksTest < ApplicationSystemTestCase
  test 'email links for buyer and seller are displayed' do
    seller      = create :legal_entity, :paypal_data
    buyer       = create :private_user
    transaction = create :business_transaction, seller: seller, buyer: buyer

    login_as buyer
    visit line_item_group_path(transaction.line_item_group)
    page.must_have_content I18n.t('line_item_group.texts.email_to_seller')

    logout
    login_as seller
    visit line_item_group_path(transaction.line_item_group)
    page.must_have_content I18n.t('line_item_group.texts.email_to_buyer')
  end
end
