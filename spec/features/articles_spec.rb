require 'spec_helper'

include Warden::Test::Helpers

describe 'Article management' do
  include CategorySeedData

  context "for signed-in users" do
    before :each do
      @user = FactoryGirl.create(:user)
      login_as @user, scope: :user
    end

    describe "article creation" do
      before do
        FactoryGirl.create(:category, :parent => nil)
        visit new_article_path
      end

      it "should have the correct title" do
        page.should have_content(I18n.t("article.titles.new"))
      end

      it 'creates an article' do
        lambda do
          fill_in I18n.t('formtastic.labels.article.title'), with: 'Article title'
          check Category.root.name
          within("#article_condition_input") do
            choose "article_condition_new"
          end

          if @user.is_a? LegalEntity
            fill_in I18n.t('formtastic.labels.article.basic_price'), with: '99,99'
            select I18n.t("enumerize.article.basic_price_amount.kilogram"), from: I18n.t('formtastic.labels.article.basic_price_amount')
          end
          fill_in I18n.t('formtastic.labels.article.content'), with: 'Article content'
          check "article_transport_pickup"
          select I18n.t("enumerize.article.default_transport.pickup") , from: I18n.t('formtastic.labels.article.default_transport')
          fill_in 'article_transport_details', with: 'transport_details'
          check "article_payment_cash"
          select I18n.t("enumerize.article.default_payment.cash") , from: I18n.t('formtastic.labels.article.default_payment')
          fill_in 'article_payment_details', with: 'payment_details'

          find(".double_check-step-inputs").find(".action").find("input").click
        end.should change(Article.unscoped, :count).by 1
      end

      it 'shows sub-categories' do
        setup_categories

        visit new_article_path
        hardware_id = Category.find_by_name!('Hardware').id

        page.should have_selector("label[for$='article_categories_and_ancestors_#{hardware_id}']", visible: false)
        check "article_categories_and_ancestors_#{Category.find_by_name!('Elektronik').id}"
        check "article_categories_and_ancestors_#{Category.find_by_name!('Computer').id}"
        page.should have_selector("label[for$='article_categories_and_ancestors_#{hardware_id}']", visible: true)
      end
    end

    describe "article search", search: true do
      before do
        article = FactoryGirl.create :article, title: 'chunky bacon'
        Sunspot.commit
        visit root_path
      end

      context "when submitting" do
        before { fill_in 'search_input', with: 'chunky bacon' }

        it "should show the page with search results" do
          click_button 'Suche'
          page.should have_link 'chunky bacon'
        end

        it "should rescue an Errno::ECONNREFUSED" do
          Sunspot.stub(:search).and_raise(Errno::ECONNREFUSED)
          click_button 'Suche'
          page.should have_content I18n.t 'article.titles.sunspot_failure'
        end
      end
    end
  end

  context "for signed-out users" do
    describe "the article index" do
      it "should be accessible" do
        visit articles_path
        page.status_code.should be 200
      end
    end
  end
end