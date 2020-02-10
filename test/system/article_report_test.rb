#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class ArticleReportTest < ApplicationSystemTestCase
  before do
    user = create :user
    sign_in user
    visit article_path create :article
  end

  test 'user reports feedback' do
    fill_in 'feedback_text', with: 'foobar'
    click_button I18n.t 'article.actions.report'

    assert page.has_content? I18n.t 'article.actions.reported'
  end

  test 'user reports blank feedback'  do
    fill_in 'feedback_text', with: ''
    click_button I18n.t 'article.actions.report'
    assert page.has_content? I18n.t 'activerecord.errors.models.feedback.attributes.text.blank'
  end
end
