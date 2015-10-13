#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

include Warden::Test::Helpers

feature 'Article Template management' do
  before do
    @user = FactoryGirl.create :user
    login_as @user, scope: :user
  end

  scenario 'article template creation has at least one correct label for the questionnaires' do
    visit new_article_template_path
    page.must_have_content(I18n.t 'formtastic.labels.fair_trust_questionnaire.support')
  end
end
