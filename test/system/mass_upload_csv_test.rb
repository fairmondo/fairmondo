#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class MassUploadCSVTest < ApplicationSystemTestCase
  setup do
    @user = create :legal_entity, :paypal_data
    sign_in @user
    visit new_mass_upload_path
  end
  test 'legal entity uploads a CSV with new articles and activates them and checks report again' do
    attach_file('mass_upload_file', 'test/fixtures/mass_upload_correct.csv')
    assert_difference 'Article.count', 3 do
      click_button I18n.t('mass_uploads.labels.upload_article')
    end
    assert page.has_content? I18n.t('users.boxes.my_mass_uploads')
    click_link I18n.t('mass_uploads.labels.show_report')
    assert page.has_content?('Name von Artikel 1')
    page.must_have_button I18n.t('mass_uploads.labels.mass_activate_articles')
    click_button I18n.t('mass_uploads.labels.mass_activate_articles')
    page.wont_have_selector('h1', text: I18n.t('mass_uploads.titles.uploaded_articles'))
    page.must_have_selector('a', text: Article.last.title)

    click_link I18n.t('mass_uploads.labels.show_report')
    page.wont_have_selector('input.Btn.Btn--green.Btn--greenSmall')
    assert page.has_content? I18n.t('mass_uploads.labels.all_articles_activated')
  end

  test 'legal entity uploads some articles activates them and updates some of them with another CSV' do
    # create articles
    attach_file('mass_upload_file', 'test/fixtures/mass_upload_correct.csv')
    click_button I18n.t('mass_uploads.labels.upload_article')
    click_link I18n.t('mass_uploads.labels.show_report')
    click_button I18n.t('mass_uploads.labels.mass_activate_articles')

    # change them
    visit new_mass_upload_path
    file = replace_ids('test/fixtures/mass_update_correct.csv', '<--ARTICLEID-->' => Article.unscoped.first.id.to_s)
    attach_file('mass_upload_file', file.path)
    click_button I18n.t('mass_uploads.labels.upload_article')
    first(:link, I18n.t('mass_uploads.labels.show_report')).click
    click_button I18n.t('mass_uploads.labels.mass_activate_articles')

    # validate changes
    article1 = Article.unscoped.first
    article2 = Article.unscoped.second
    article1.content.must_equal 'Andere Beschreibung'
    article1.condition.must_equal 'old'
    article2.title.must_equal 'Anderer Name'
    article2.gtin.must_equal '9999999999'
    article1.active?.must_equal true
    article2.active?.must_equal true
    Article.unscoped.third.title.must_equal 'Name von Artikel 3'
  end

  test 'legal entity uploads some articles activates them; articles aresold and updated with another CSV' do
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

    file = replace_ids('test/fixtures/mass_update_correct.csv', '<--ARTICLEID-->' => Article.unscoped.first.id.to_s)
    attach_file('mass_upload_file', file.path)
    click_button I18n.t('mass_uploads.labels.upload_article')
    first(:link, I18n.t('mass_uploads.labels.show_report')).click
    click_button I18n.t('mass_uploads.labels.mass_activate_articles')

    # validate changes
    Article.unscoped.first.active?.must_equal false
    Article.unscoped.second.active?.must_equal false
    article1 = Article.unscoped.fourth # as it will edit them both as new
    article2 = Article.unscoped.fifth
    article1.content.must_equal 'Andere Beschreibung'
    article1.condition.must_equal 'old'
    article2.title.must_equal 'Anderer Name'
    article2.gtin.must_equal '9999999999'
    article1.active?.must_equal true
    article2.active?.must_equal true
    Article.unscoped.third.title.must_equal 'Name von Artikel 3'
  end

  test 'legal entity deletes an Articles via CSV' do
    article = create :article, seller: @user
    second_article = create :article, custom_seller_identifier: 'abc123', seller: @user
    file = replace_ids('test/fixtures/mass_delete.csv', '<--ARTICLEID-->' => article.id.to_s)
    attach_file('mass_upload_file', file.path)
    click_button I18n.t('mass_uploads.labels.upload_article')
    article.reload.closed?.must_equal true
    article.reload.closed?.must_equal true
  end

  test 'legal entity tries to delete an already closed Article via CSV' do
    create :closed_article, seller: @user
    file = replace_ids( 'test/fixtures/mass_upload_single_delete.csv', '<--ARTICLEID-->' => Article.unscoped.first.id.to_s)
    attach_file('mass_upload_file', file.path)
    click_button I18n.t('mass_uploads.labels.upload_article')
    click_link I18n.t('mass_uploads.labels.show_report')
    assert page.has_content? I18n.t('mass_uploads.errors.article_not_found')
  end

  test 'legal entity activates preview articles via CSV' do
    article = create :preview_article, seller: @user
    second_article = create :preview_article, custom_seller_identifier: 'abc123', seller: @user
    file = replace_ids('test/fixtures/mass_activate.csv', '<--ARTICLEID-->' => article.id.to_s)
    attach_file('mass_upload_file', file.path)
    click_button I18n.t('mass_uploads.labels.upload_article')
    click_link I18n.t('mass_uploads.labels.show_report')
    click_button I18n.t('mass_uploads.labels.mass_activate_articles')
    article.reload.active?.must_equal true
    second_article.reload.active?.must_equal true
  end

  test 'legal entity deactivates Articles via CSV' do
    article = create :article, seller: @user
    second_article = create :article, custom_seller_identifier: 'abc123', seller: @user
    file = replace_ids('test/fixtures/mass_deactivate.csv', '<--ARTICLEID-->' => article.id.to_s)
    attach_file('mass_upload_file', file.path)
    click_button I18n.t('mass_uploads.labels.upload_article')
    article.reload.locked?.must_equal true
    second_article.reload.locked?.must_equal true
  end

  test 'legal entity tries to delete an article that belongs to another user' do
    article = create :article

    file = replace_ids('test/fixtures/mass_upload_single_delete.csv', '<--ARTICLEID-->' => article.id.to_s)
    attach_file('mass_upload_file', file.path)
    click_button I18n.t('mass_uploads.labels.upload_article')
    click_link I18n.t('mass_uploads.labels.show_report')

    assert page.has_content? I18n.t('mass_uploads.errors.article_not_found')
    article.reload.closed?.must_equal false
  end

  test 'legal entity tries to delete articles that are not present' do
    attach_file('mass_upload_file', 'test/fixtures/mass_deactivate.csv')
    click_button I18n.t('mass_uploads.labels.upload_article')
    click_link I18n.t('mass_uploads.labels.show_report')
    assert page.has_content?(I18n.t('mass_uploads.errors.article_not_found'))
  end

  test 'legal entity uploads a file with an activate request but no id' do
    attach_file('mass_upload_file', 'test/fixtures/mass_activate_without_id.csv')
    click_button I18n.t('mass_uploads.labels.upload_article')
    click_link I18n.t('mass_uploads.labels.show_report')
    assert page.has_content?(I18n.t('mass_uploads.errors.no_identifier'))
  end

  test 'legal entity uploads a file with an Article without an action but an id' do
    create :article, seller: @user
    attach_file('mass_upload_file', 'test/fixtures/mass_upload_without_action.csv')
    click_button I18n.t('mass_uploads.labels.upload_article')
    Article.unscoped.size.must_equal 1
  end

  test 'legal entity uploads a file that contains Articles with various actions' do
    a1 = create :article, seller: @user
    a2 = create :preview_article, seller: @user
    a3 = create :article, seller: @user
    a4 = create :article, seller: @user # problems with dup and images while testing
    a5 = create :preview_article, seller: @user

    file = replace_ids('test/fixtures/mass_upload_correct_multiple_action.csv',
                       '<--ARTICLEID1-->' => a1.id.to_s,
                       '<--ARTICLEID2-->' => a2.id.to_s,
                       '<--ARTICLEID3-->' => a3.id.to_s,
                       '<--ARTICLEID4-->' => a4.id.to_s,
                       '<--ARTICLEID5-->' => a5.id.to_s)
    attach_file('mass_upload_file', file.path)
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

  test 'legal entity uploads a file with an unknown action' do
    create :article, seller: @user

    attach_file('mass_upload_file', 'test/fixtures/mass_upload_wrong_action.csv')
    click_button I18n.t('mass_uploads.labels.upload_article')
    click_link I18n.t('mass_uploads.labels.show_report')

    assert page.has_content? I18n.t('mass_uploads.errors.unknown_action')
  end

  test 'legal entity uploads a file with invalid articles' do
    attach_file('mass_upload_file', 'test/fixtures/mass_upload_wrong_article.csv')
    assert_no_difference 'Article.count' do
      click_button I18n.t('mass_uploads.labels.upload_article')
    end
    click_link I18n.t('mass_uploads.labels.show_report')
    assert page.has_content?(I18n.t('mass_uploads.errors.wrong_article_message'))
  end

  test 'legal entity uploads a file with an invalid encoding' do
    skip 'encoding detection changed in newer ruby version, so we can not reliably detect this any more'
    attach_file('mass_upload_file', 'test/fixtures/mass_upload_wrong_encoding.csv')
    click_button I18n.t('mass_uploads.labels.upload_article')
    assert page.has_content?(I18n.t('mass_uploads.errors.wrong_encoding'))
  end

  test 'legal entity uploads a file with illegal quoting' do
    attach_file('mass_upload_file', 'test/fixtures/mass_upload_illegal_quoting.csv')
    click_button I18n.t('mass_uploads.labels.upload_article')
    assert page.has_content?(I18n.t('mass_uploads.errors.illegal_quoting'))
  end

  def replace_ids(file, replace_ids)
    string = File.read(file)
    updated_string = replace_ids.inject(string) do |result, (k, v)|
      result.gsub(k, v)
    end
    Tempfile.new(['upload', '.csv']).tap do |f|
      f.write(updated_string)
      f.close
    end
  end
end
