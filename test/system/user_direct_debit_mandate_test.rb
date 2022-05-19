#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class UserDirectDebitMandateTest < ApplicationSystemTestCase
  setup do
    @user = create :legal_entity, :fastbill
    sign_in @user
  end

  test 'User accepts direct debit after which a mandate is created' do
    visit edit_user_registration_path(@user)
    check 'user_direct_debit_confirmation'
    click_button I18n.t('formtastic.actions.update')

    assert @user.reload.has_active_direct_debit_mandate?

    # Assert 2 requests to Fastbill, one customer.get, one customer.update (both are POST requests)
    # User is saved two times, therefore 4 requests
    assert_requested :post, 'https://app.monsum.com/api/1.0/api.php', times: 4
  end

  test 'Direct debit mandate reference is shown if present' do
    mandate = CreatesDirectDebitMandate.new(@user).create

    visit edit_user_registration_path(@user)

    assert page.has_content? mandate.reference
    assert page.has_content? I18n.l(mandate.reference_date)
  end

  test 'Direct debit mandate is revoked if user changes bank details' do
    CreatesDirectDebitMandate.new(@user).create

    visit edit_user_registration_path(@user)

    fill_in 'iban', with: 'DE12500105170648489890'
    click_button I18n.t('formtastic.actions.update')

    refute @user.reload.has_active_direct_debit_mandate?
    # Assert 2 requests to Fastbill, one customer.get, one customer.update (both are POST requests)
    assert_requested :post, 'https://app.monsum.com/api/1.0/api.php', times: 2
    assert page.has_content? I18n.t('devise.registrations.direct_debit_mandate_revoked')
  end
end
