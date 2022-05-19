#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class UserExportTransactionsTest < ApplicationSystemTestCase
  test 'private user looks at his profile' do
    user = create :private_user
    sign_in user
    visit user_path(user)

    refute page.has_content? 'CSV-Export Bestellungen'
  end

  test 'legal entity looks at her profile' do
    user = create :legal_entity
    sign_in user
    visit user_path(user)

    assert page.has_content? 'CSV-Export Bestellungen'

    select('Mai', from: 'date_month')
    select('2016', from: 'date_year')
    click_button 'export_business_transactions_submit'
    # TODO: Test for file download, apparently Selenium is needed
  end
end
