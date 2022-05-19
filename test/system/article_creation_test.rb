#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class ArticleCreationTest < ApplicationSystemTestCase
  before do
    @user = create :user
    sign_in @user
  end

  test 'article creation with an invalid user should redirect with an error' do
    @user.standard_address.first_name = nil
    visit new_article_path
    current_path.must_equal edit_user_registration_path
    assert page.has_content? I18n.t 'article.notices.incomplete_profile'
  end

  def fill_form_with_valid_article
    fill_in I18n.t('formtastic.labels.article.title'), with: 'Article title'

    within('#article_category_ids_input') do
      select Category.root.name, from: 'article_category_ids'
    end
    within('#article_condition_input') do
      choose 'article_condition_new'
    end

    fill_in I18n.t('formtastic.labels.article.price'), with: '5,00'

    if @user.is_a? LegalEntity
      fill_in I18n.t('formtastic.labels.article.basic_price'), with: '99,99'
      select I18n.t('enumerize.article.basic_price_amount.kilogram'), from: I18n.t('formtastic.labels.article.basic_price_amount')
      select 7, from: I18n.t('formtastic.labels.article.vat')
    end
    fill_in I18n.t('formtastic.labels.article.content'), with: 'Article content'
    check 'article_transport_pickup'
    fill_in 'article_transport_details', with: 'transport_details'
    check 'article_payment_cash'
    fill_in 'article_payment_details', with: 'payment_details'
  end

  test 'article and template creation with a valid user' do
    visit new_article_path
    assert page.has_content?(I18n.t('article.titles.new'))

    fill_form_with_valid_article

    # social producer
    check 'article_fair'
    within('#article_fair_kind_input') do
      choose 'article_fair_kind_social_producer'
    end
    within('#article_social_producer_questionnaire_attributes_nonprofit_association_input') do
      choose 'article_social_producer_questionnaire_attributes_nonprofit_association_true'
    end
    check 'article_social_producer_questionnaire_attributes_nonprofit_association_checkboxes_youth_and_elderly'
    within('#article_social_producer_questionnaire_attributes_social_businesses_muhammad_yunus_input') do
      choose 'article_social_producer_questionnaire_attributes_social_businesses_muhammad_yunus_false'
    end
    within('#article_social_producer_questionnaire_attributes_social_entrepreneur_input') do
      choose 'article_social_producer_questionnaire_attributes_social_entrepreneur_false'
    end

    # Template
    fill_in 'article_article_template_name', with: 'template'
    assert_difference 'Article.unscoped.count', 2 do
      click_button I18n.t('article.labels.continue_to_preview')
    end

    current_path.must_equal article_path Article.first
  end

  test 'article creation with a quantity higher than 1' do
    visit new_article_path

    fill_form_with_valid_article

    # Increase Quantity
    fill_in 'article_quantity', with: '2'

    assert_difference 'Article.unscoped.count', 1 do
      click_button I18n.t('article.labels.continue_to_preview')
    end
  end

  test 'empty friendly_percent_organisation with friendly_percent' do
    visit new_article_path
    fill_form_with_valid_article
    # choose friendly_percent
    select('35', from: 'article_friendly_percent')

    assert_no_difference 'Article.unscoped.count'  do
      click_button I18n.t('article.labels.continue_to_preview')
    end
  end

  test 'get article from template' do
    template = create :article_template, seller: @user
    visit new_article_path template: { article_id: template.id }
    assert page.has_content? I18n.t('template.notices.applied', name: template.article_template_name)
  end

  test 'new private user wants to use bank_transfer for article that costs more than 100Euro' do
    @user = create :private_user, created_at: Time.now
    sign_in @user
    visit new_article_path
    fill_form_with_valid_article
    fill_in 'article_price', with: '150'
    check 'article_payment_bank_transfer'
    click_button I18n.t('article.labels.continue_to_preview')
    assert page.has_content? I18n.t('article.form.errors.bank_transfer_not_allowed')
  end
end
