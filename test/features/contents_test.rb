#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

include Warden::Test::Helpers

feature 'CMS System' do
  let(:content) { FactoryGirl.create :content }
  let(:admin) { FactoryGirl.create :admin_user }

  scenario 'user visits an existing page' do
    visit content_path content
    page.must_have_content content.body
  end

  scenario 'admin visits a non existing page' do
    login_as admin
    visit content_path 'not-there'
    current_path.must_equal new_content_path
  end
  scenario 'guest visit non existing page' do
    -> { visit content_path 'not-there' }.must_raise ActiveRecord::RecordNotFound
  end

  scenario 'admin visits content index' do
    login_as admin
    visit contents_path
    current_path.must_equal contents_path
  end

  scenario 'guest visits content index' do
    visit contents_path
    current_path.must_equal new_user_session_path
  end

  scenario 'admin creates content' do
    login_as admin
    visit new_content_path

    fill_in 'content_key', with: 'foobar'
    fill_in 'content_body', with: 'Bazfuz'

    assert_difference 'Content.count', 1 do
      click_button I18n.t 'helpers.submit.create', model: (I18n.t 'activerecord.models.content.one')
    end

    page.must_have_content 'CMS-Seite wurde erstellt.'
    page.must_have_content 'Bazfuz'
  end

  scenario 'admin updates content' do
    login_as admin
    visit edit_content_path content
    fill_in 'content_key', with: 'foobar'
    fill_in 'content_body', with: 'Bazfuz'
    click_button I18n.t 'helpers.submit.update', model: (I18n.t 'activerecord.models.content.one')
    page.must_have_content 'CMS-Seite wurde aktualisiert.'
    page.must_have_content 'Bazfuz'
  end

  scenario 'admin deletes content' do
    login_as admin
    content
    visit contents_path
    assert_difference 'Content.count', -1 do
      click_link 'Löschen'
    end
  end

  scenario '[articles ids="a b c d"] is expanded to four article previews in a grid' do
    user = FactoryGirl.create(:user)
    article_ids = []
    (1..8).each do |n|
      article_ids << FactoryGirl.create(:article, title: "Book #{n}", seller: user).id
    end
    body = create_body_with_articles(article_ids)
    content = FactoryGirl.create(:content, body: body)

    visit content_path content

    (1..8).each do |n|
      page.must_have_content "Book #{n}"
    end
  end

  def create_body_with_articles(article_ids)
    articles1 = article_ids[0..3].join(' ')
    articles2 = article_ids[4..7].join(' ')
    "<p>[articles ids=\"#{articles1}\"]</p>
     <p>[articles ids=\"#{articles2}\"]</p>"
  end

  scenario '[articles ids="a b c d"] is not expanded if articles cannot be found' do
    content = FactoryGirl.create(:content, body: "<p>[articles ids=\"1 2 3 4\"]</p>")

    visit content_path content

    page.must_have_content ActionController::Base.helpers
      .strip_tags(I18n.t('tinycms.content.article_not_found_html'))
  end
end
