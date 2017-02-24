#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

include Warden::Test::Helpers

feature 'Access Mass-upload form' do
  scenario 'guests wants to have a new mass_upload' do
    visit new_mass_upload_path
    current_path.must_equal new_user_session_path
  end

  scenario 'private user wants to access a new mass_upload over new Articles page' do
    login_as create :private_user
    visit new_article_path
    page.wont_have_link(I18n.t('users.boxes.import'), href: new_mass_upload_path)
  end

  scenario 'legal_entity user wants to access a new mass_upload over new Articles page' do
    user = create :legal_entity
    login_as user

    visit new_article_path
    page.must_have_link(I18n.t('users.boxes.import'))
  end
end

feature 'Uploading a CSV' do
  setup do
    @user = create :legal_entity, :paypal_data
    login_as @user
    visit new_mass_upload_path
  end
  scenario 'legal entity uploads a CSV with new articles and activates them and checks report again' do
    attach_file('mass_upload_file', 'test/fixtures/mass_upload_correct.csv')
    assert_difference 'Article.count', 3 do
      click_button I18n.t('mass_uploads.labels.upload_article')
    end
    page.must_have_content I18n.t('users.boxes.my_mass_uploads')
    click_link I18n.t('mass_uploads.labels.show_report')
    page.must_have_content('Name von Artikel 1')
    page.must_have_button I18n.t('mass_uploads.labels.mass_activate_articles')
    click_button I18n.t('mass_uploads.labels.mass_activate_articles')
    page.wont_have_selector('h1', text: I18n.t('mass_uploads.titles.uploaded_articles'))
    page.must_have_selector('a', text: Article.last.title)

    click_link I18n.t('mass_uploads.labels.show_report')
    page.wont_have_selector('input.Btn.Btn--green.Btn--greenSmall')
    page.must_have_content I18n.t('mass_uploads.labels.all_articles_activated')
  end

  scenario 'legal entity uploads some articles activates them and updates some of them with another CSV' do
    # create articles
    attach_file('mass_upload_file', 'test/fixtures/mass_upload_correct.csv')
    click_button I18n.t('mass_uploads.labels.upload_article')
    click_link I18n.t('mass_uploads.labels.show_report')
    click_button I18n.t('mass_uploads.labels.mass_activate_articles')

    # change them
    visit new_mass_upload_path
    attach_file('mass_upload_file', 'test/fixtures/mass_update_correct.csv')
    click_button I18n.t('mass_uploads.labels.upload_article')
    first(:link, I18n.t('mass_uploads.labels.show_report')).click
    click_button I18n.t('mass_uploads.labels.mass_activate_articles')

    # validate changes
    article1 = Article.find(1)
    article2 = Article.find(2)
    article1.content.must_equal 'Andere Beschreibung'
    article1.condition.must_equal 'old'
    article2.title.must_equal 'Anderer Name'
    article2.gtin.must_equal '9999999999'
    article1.active?.must_equal true
    article2.active?.must_equal true
    Article.find(3).title.must_equal 'Name von Artikel 3'
  end

  scenario 'legal entity uploads some articles activates them; articles aresold and updated with another CSV' do
    # create articles
    attach_file('mass_upload_file', 'test/fixtures/mass_upload_correct.csv')
    click_button I18n.t('mass_uploads.labels.upload_article')
    click_link I18n.t('mass_uploads.labels.show_report')
    click_button I18n.t('mass_uploads.labels.mass_activate_articles')

    # sell all articles
    Article.all.each do |article|
      create :business_transaction, :pickup, article: article, line_item_group: (create :line_item_group, :sold, articles: [article])
    end

    # change them
    visit new_mass_upload_path
    attach_file('mass_upload_file', 'test/fixtures/mass_update_correct.csv')
    click_button I18n.t('mass_uploads.labels.upload_article')
    first(:link, I18n.t('mass_uploads.labels.show_report')).click
    click_button I18n.t('mass_uploads.labels.mass_activate_articles')

    # validate changes
    Article.find(1).active?.must_equal false
    Article.find(2).active?.must_equal false
    article1 = Article.find(4) # as it will edit them both as new
    article2 = Article.find(5)
    article1.content.must_equal 'Andere Beschreibung'
    article1.condition.must_equal 'old'
    article2.title.must_equal 'Anderer Name'
    article2.gtin.must_equal '9999999999'
    article1.active?.must_equal true
    article2.active?.must_equal true
    Article.find(3).title.must_equal 'Name von Artikel 3'
  end

  scenario 'legal entity deletes an Articles via CSV' do
    create :article, seller: @user
    create :article, custom_seller_identifier: 'abc123', seller: @user
    attach_file('mass_upload_file', 'test/fixtures/mass_delete.csv')
    click_button I18n.t('mass_uploads.labels.upload_article')
    Article.find(1).closed?.must_equal true
    Article.find(2).closed?.must_equal true
  end

  scenario 'legal entity tries to delete an already closed Article via CSV' do
    create :closed_article, seller: @user
    attach_file('mass_upload_file', 'test/fixtures/mass_upload_single_delete.csv')
    click_button I18n.t('mass_uploads.labels.upload_article')
    click_link I18n.t('mass_uploads.labels.show_report')
    page.must_have_content I18n.t('mass_uploads.errors.article_not_found')
  end

  scenario 'legal entity activates preview articles via CSV' do
    create :preview_article, seller: @user
    create :preview_article, custom_seller_identifier: 'abc123', seller: @user
    attach_file('mass_upload_file', 'test/fixtures/mass_activate.csv')
    click_button I18n.t('mass_uploads.labels.upload_article')
    click_link I18n.t('mass_uploads.labels.show_report')
    click_button I18n.t('mass_uploads.labels.mass_activate_articles')
    Article.find(1).active?.must_equal true
    Article.find(2).active?.must_equal true
  end

  scenario 'legal entity deactivates Articles via CSV' do
    create :article, seller: @user
    create :article, custom_seller_identifier: 'abc123', seller: @user
    attach_file('mass_upload_file', 'test/fixtures/mass_deactivate.csv')
    click_button I18n.t('mass_uploads.labels.upload_article')
    Article.find(1).locked?.must_equal true
    Article.find(2).locked?.must_equal true
  end

  scenario 'legal entity tries to delete an article that belongs to another user' do
    create :article

    attach_file('mass_upload_file', 'test/fixtures/mass_upload_single_delete.csv')
    click_button I18n.t('mass_uploads.labels.upload_article')
    click_link I18n.t('mass_uploads.labels.show_report')

    page.must_have_content I18n.t('mass_uploads.errors.article_not_found')
    Article.find(1).closed?.must_equal false
  end

  scenario 'legal entity tries to delete articles that are not present' do
    attach_file('mass_upload_file', 'test/fixtures/mass_deactivate.csv')
    click_button I18n.t('mass_uploads.labels.upload_article')
    click_link I18n.t('mass_uploads.labels.show_report')
    page.must_have_content(I18n.t('mass_uploads.errors.article_not_found'))
  end

  scenario 'legal entity uploads a file with an activate request but no id' do
    attach_file('mass_upload_file', 'test/fixtures/mass_activate_without_id.csv')
    click_button I18n.t('mass_uploads.labels.upload_article')
    click_link I18n.t('mass_uploads.labels.show_report')
    page.must_have_content(I18n.t('mass_uploads.errors.no_identifier'))
  end

  scenario 'legal entity uploads a file with an Article without an action but an id' do
    create :article, seller: @user
    attach_file('mass_upload_file', 'test/fixtures/mass_upload_without_action.csv')
    click_button I18n.t('mass_uploads.labels.upload_article')
    Article.unscoped.size.must_equal 1
  end

  scenario 'legal entity uploads a file that contains Articles with various actions' do
    a1 = create :article, seller: @user
    a2 = create :preview_article, seller: @user
    a3 = create :article, seller: @user
    a4 = create :article, seller: @user # problems with dup and images while testing
    a5 = create :preview_article, seller: @user

    attach_file('mass_upload_file', 'test/fixtures/mass_upload_correct_multiple_action.csv')
    click_button I18n.t('mass_uploads.labels.upload_article')
    click_link I18n.t('mass_uploads.labels.show_report')
    click_button I18n.t('mass_uploads.labels.mass_activate_articles')

    a1.reload.closed?.must_equal true
    a2.reload.active?.must_equal true
    a3.reload.locked?.must_equal true
    a4.reload.active?.must_equal true
    a5.reload.active?.must_equal true
    Article.unscoped.size.must_equal 8 # 5 created by factory, 3 createdby csv
    Article.unscoped.where(title: 'neuer titel').size.must_equal 2
  end

  scenario 'legal entity uploads a file with an unknown action' do
    create :article, seller: @user

    attach_file('mass_upload_file', 'test/fixtures/mass_upload_wrong_action.csv')
    click_button I18n.t('mass_uploads.labels.upload_article')
    click_link I18n.t('mass_uploads.labels.show_report')

    page.must_have_content I18n.t('mass_uploads.errors.unknown_action')
  end

  scenario 'legal entity uploads a file with invalid articles' do
    attach_file('mass_upload_file', 'test/fixtures/mass_upload_wrong_article.csv')
    assert_no_difference 'Article.count' do
      click_button I18n.t('mass_uploads.labels.upload_article')
    end
    click_link I18n.t('mass_uploads.labels.show_report')
    page.must_have_content(I18n.t('mass_uploads.errors.wrong_article_message'))
  end

  scenario 'legal entity uploads a file with an invalid encoding' do
    attach_file('mass_upload_file', 'test/fixtures/mass_upload_wrong_encoding.csv')
    click_button I18n.t('mass_uploads.labels.upload_article')
    page.must_have_content(I18n.t('mass_uploads.errors.wrong_encoding'))
  end

  scenario 'legal entity uploads a file with illegal quoting' do
    attach_file('mass_upload_file', 'test/fixtures/mass_upload_illegal_quoting.csv')
    click_button I18n.t('mass_uploads.labels.upload_article')
    page.must_have_content(I18n.t('mass_uploads.errors.illegal_quoting'))
  end
end
