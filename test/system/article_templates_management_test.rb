#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class ArticleTemplatesManagementTest < ApplicationSystemTestCase
  before do
    @user = create :user
    sign_in @user, scope: :user
  end

  test 'article template creation has at least one correct label for the questionnaires' do
    visit new_article_template_path
    assert page.has_content?(I18n.t('formtastic.labels.fair_trust_questionnaire.support').strip)
  end
end
