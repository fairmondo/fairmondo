#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class MassUploadFormTest < ApplicationSystemTestCase
  test 'guests wants to have a new mass_upload' do
    visit new_mass_upload_path
    current_path.must_equal new_user_session_path
  end

  test 'private user wants to access a new mass_upload over new Articles page' do
    sign_in create :private_user
    visit new_article_path
    page.wont_have_link(I18n.t('users.boxes.import'), href: new_mass_upload_path)
  end

  test 'legal_entity user wants to access a new mass_upload over new Articles page' do
    user = create :legal_entity
    sign_in user

    visit new_article_path
    assert page.has_link?(I18n.t('users.boxes.import'))
  end
end
