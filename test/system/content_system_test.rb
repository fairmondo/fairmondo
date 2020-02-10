#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class ContentSystemTest < ApplicationSystemTestCase
  let(:content) { create :content }
  let(:admin) { create :admin_user }

  test 'user visits an existing page' do
    visit content_path content
    assert page.has_content? content.body
  end

  test 'admin visits a non existing page' do
    sign_in admin
    visit content_path 'not-there'
    current_path.must_equal new_content_path
  end
  test 'guest visit non existing page' do
    -> { visit content_path 'not-there' }.must_raise ActiveRecord::RecordNotFound
  end

  test 'admin visits content index' do
    sign_in admin
    visit contents_path
    current_path.must_equal contents_path
  end

  test 'guest visits content index' do
    visit contents_path
    current_path.must_equal new_user_session_path
  end

  test 'admin creates content' do
    sign_in admin
    visit new_content_path

    fill_in 'content_key', with: 'foobar'
    fill_in 'content_body', with: 'Bazfuz'

    assert_difference 'Content.count', 1 do
      click_button I18n.t 'helpers.submit.create', model: (I18n.t 'activerecord.models.content.one')
    end

    assert page.has_content? 'CMS-Seite wurde erstellt.'
    assert page.has_content? 'Bazfuz'
  end

  test 'admin updates content' do
    sign_in admin
    visit edit_content_path content
    fill_in 'content_key', with: 'foobar'
    fill_in 'content_body', with: 'Bazfuz'
    click_button I18n.t 'helpers.submit.update', model: (I18n.t 'activerecord.models.content.one')
    assert page.has_content? 'CMS-Seite wurde aktualisiert.'
    assert page.has_content? 'Bazfuz'
  end

  test 'admin deletes content' do
    sign_in admin
    content
    visit contents_path
    assert_difference 'Content.count', -1 do
      click_link 'Löschen'
    end
  end

  test '[articles ids="a"] is expanded to one article preview in a grid' do
    article_id = create(:article, title: 'Book 1').id
    body = "<p>[articles ids=\"#{article_id}\"]</p>"
    content = create(:content, body: body)

    visit content_path content

    assert page.has_content? 'Book 1'
  end

  test '[articles ids="a b"], [articles ids="a b c"] and [articles ids="a b c d"] are expanded accordingly' do
    user = create(:user)
    article_ids = []
    (1..9).each do |n|
      article_ids << create(:article, title: "Book #{n}", seller: user).id
    end
    body = create_body_with_articles(article_ids)
    content = create(:content, body: body)

    visit content_path content

    (1..9).each do |n|
      assert page.has_content? "Book #{n}"
    end
  end

  def create_body_with_articles(article_ids)
    two_articles = article_ids[0..1].join(' ')
    three_articles = article_ids[2..4].join(' ')
    four_articles = article_ids[5..8].join(' ')
    "<p>[articles ids=\"#{two_articles}\"]</p>
     <p>[articles ids=\"#{three_articles}\"]</p>
     <p>[articles ids=\"#{four_articles}\"]</p>"
  end

  test '[articles ids="a b c d"] is not expanded if articles cannot be found' do
    content = create(:content, body: "<p>[articles ids=\"1 2 3 4\"]</p>")

    visit content_path content

    assert page.has_content? ActionController::Base.helpers
      .strip_tags(I18n.t('tinycms.content.article_not_found_html'))
  end
end
