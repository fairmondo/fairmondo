#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class EmptyCartTest < ApplicationSystemTestCase
  it 'header should show link to empty cart' do
    visit root_path
    page.html.must_include I18n.t('header.cart.title', count: 0)
    click_link(I18n.t('header.cart.title', count: 0), match: :first)
    assert page.has_content? 'Dein Warenkorb ist leer.'
  end
end
