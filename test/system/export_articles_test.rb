#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class ExportArticlesTest < ApplicationSystemTestCase
  let(:private_user)       { create :private_user }
  let(:legal_entity)       { create :legal_entity, :paypal_data, direct_debit_exemption: true }
  let(:legal_entity_buyer) { create :legal_entity, email: 'hans@dampf.de' }

  test 'private user is on his profile and should not see export link' do
    sign_in private_user
    visit user_path(private_user)
    page.wont_have_link I18n.t('articles.export.inactive')
  end

  test 'legal entity exports his inactive and active articles' do
    Indexer.stubs(:index_mass_upload)

    sign_in legal_entity
    visit new_mass_upload_path

    # first upload some articles for comparison
    attach_file('mass_upload_file', 'test/fixtures/mass_upload_correct_upload_export_test.csv')
    click_button I18n.t('mass_uploads.labels.upload_article')

    visit user_path(legal_entity)

    click_link I18n.t('articles.export.inactive')

    page.source.must_equal expected_csv('test/fixtures/mass_upload_export.csv', Article.last.id)
    visit user_path(legal_entity)
    # activate all articles
    click_link I18n.t('mass_uploads.labels.show_report')
    click_button I18n.t('mass_uploads.labels.mass_activate_articles')

    visit user_path(legal_entity)
    click_link I18n.t('articles.export.active')

    page.source.must_equal expected_csv('test/fixtures/mass_upload_export.csv', Article.last.id)
  end

  test 'export an article with a social producer questionnaire' do
    sign_in legal_entity
    visit new_mass_upload_path
    attach_file('mass_upload_file', 'test/fixtures/export_upload_social_producer.csv')
    click_button I18n.t('mass_uploads.labels.upload_article')
    click_link I18n.t('articles.export.inactive')

    page.source.must_equal expected_csv('test/fixtures/export_social_producer.csv', Article.last.id)
  end

  test 'user exports erroneous articles' do
    sign_in legal_entity
    visit new_mass_upload_path
    attach_file('mass_upload_file', 'test/fixtures/mass_upload_wrong_article.csv')
    click_button I18n.t('mass_uploads.labels.upload_article')
    visit mass_upload_path(MassUpload.last)
    click_link 'Fehlerhafte Artikel exportieren'
    page.source.must_equal IO.read('test/fixtures/mass_upload_wrong_article.csv')
  end

  def expected_csv(file_path, article_id)
    string = IO.read(file_path, encoding: 'ascii-8bit')
    string.gsub('<--ARTICLEID-->', article_id.to_s)
  end
end
