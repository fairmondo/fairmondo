#
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
require 'spec_helper'

include Warden::Test::Helpers

describe 'Article management' do

  let(:article) { FactoryGirl.create :article }
  let(:article_active) { FactoryGirl.create :article, :user_id => user.id }
  let(:article_locked) { FactoryGirl.create :preview_article, :user_id => user.id }
  let(:user) { FactoryGirl.create :user }

  context "for signed-in users" do

    before :each do
      login_as user, scope: :user
    end

    describe "article creation" do

      context "with an invalid user" do
        before { user.forename = nil }

        it "should redirect with an error" do
          visit new_article_path
          current_path.should eq edit_user_registration_path
          page.should have_content I18n.t 'article.notices.incomplete_profile'
        end
      end

      context "with a valid user", slow: true do
        def fill_form_with_valid_article
          fill_in I18n.t('formtastic.labels.article.title'), with: 'Article title'

          within("#article_category_ids_input") do
            select Category.root.name, from: 'article_category_ids'
          end
          within("#article_condition_input") do
            choose "article_condition_new"
          end

          if user.is_a? LegalEntity
            fill_in I18n.t('formtastic.labels.article.basic_price'), with: '99,99'
            select I18n.t("enumerize.article.basic_price_amount.kilogram"), from: I18n.t('formtastic.labels.article.basic_price_amount')
            if user.country == "Deutschland"
              select 7 ,from: I18n.t('formtastic.labels.article.vat')
            end
          end
          fill_in I18n.t('formtastic.labels.article.content'), with: 'Article content'
          check "article_transport_pickup"
          fill_in 'article_transport_details', with: 'transport_details'
          check "article_payment_cash"
          fill_in 'article_payment_details', with: 'payment_details'
        end

        before do
          FactoryGirl.create :category, parent: nil
          visit new_article_path
        end

        it "should have the correct title" do
          page.should have_content(I18n.t("article.titles.new"))
        end

        it "should show the create article page when selecting no template" do
          visit new_article_path template: { article_id: "" }
          current_path.should == new_article_path
        end

        it 'should create an article plus a template', visual: true do
          lambda do
            fill_form_with_valid_article

            # social producer
            check "article_fair"
            within("#article_fair_kind_input") do
              choose "article_fair_kind_social_producer"
            end
            within("#article_social_producer_questionnaire_attributes_nonprofit_association_input") do
              choose "article_social_producer_questionnaire_attributes_nonprofit_association_true"
            end
            check "article_social_producer_questionnaire_attributes_nonprofit_association_checkboxes_youth_and_elderly"
            within("#article_social_producer_questionnaire_attributes_social_businesses_muhammad_yunus_input") do
              choose "article_social_producer_questionnaire_attributes_social_businesses_muhammad_yunus_false"
            end
            within("#article_social_producer_questionnaire_attributes_social_entrepreneur_input") do
              choose "article_social_producer_questionnaire_attributes_social_entrepreneur_false"
            end

            # Image
            #attach_file "article_images_attributes_0_image", Rails.root.join('spec', 'fixtures', 'test.png')
            # Doesn't work correctly at the moment

            # Template
            check 'article_save_as_template'
            fill_in 'article_template_name', with: 'template'

            click_button I18n.t("article.labels.continue_to_preview")
          end.should change(Article.unscoped, :count).by 2

          current_path.should eq article_path Article.first
          Article.find('article-title').business_transaction.should be_a SingleFixedPriceTransaction
        end

        it "should create an article with a MultipleFixedPriceTransaction", visual: true do
          lambda do
            fill_form_with_valid_article

            # Increase Quantity
            fill_in 'article_quantity', with: '2'

            # Template -> should still only create one transaction
            check 'article_save_as_template'
            fill_in 'article_template_name', with: 'template'

            click_button I18n.t("article.labels.continue_to_preview")
          end.should change(BusinessTransaction, :count).by 1

          Article.find('article-title').business_transaction.should be_a MultipleFixedPriceTransaction
        end

        it "should validate the friendly_percent_organisation if the article has friendly_percent" do
          lambda do
            fill_form_with_valid_article
            # choose friendly_percent
            select('35', :from => 'article_friendly_percent')

            click_button I18n.t("article.labels.continue_to_preview")
          end.should change(Article, :count).by 0

        end

         it "should create an article from a template" do
          template = FactoryGirl.create :article_template, :without_image, seller: user
          visit new_article_path template: { article_id: template.id }
          page.should have_content I18n.t('template.notices.applied', name: template.template_name)
        end

        context "for private users" do
          let(:user) { FactoryGirl.create :private_user }

          it "should have the default maximum for value of goods" do
            user.max_value_of_goods_cents.should eq 500000
          end

          it "should add the bonus to the maximum for value of goods" do

            user.max_value_of_goods_cents.should eq 500000
          end

          it "should fail to create an article, if the value of goods crosses its max value of goods" do
            article = FactoryGirl.create :article, :user_id => user.id
            article.update_attribute(:price_cents, 600000)
            article2 = FactoryGirl.create :preview_article, :user_id => user.id
            login_as user
            visit article_path(article2)
            click_button I18n.t("article.labels.submit")
            page.should have_content I18n.t('article.notices.max_limit')
          end

          it "should add bonus to max value of goods" do
            user.update_attribute(:max_value_of_goods_cents_bonus, 200000)
            article = FactoryGirl.create :article, :user_id => user.id
            article.update_attribute(:price_cents, 600000)
            article2 = FactoryGirl.create :preview_article, :user_id => user.id
            login_as user
            visit article_path(article2)
            click_button I18n.t("article.labels.submit")
            page.should_not have_content I18n.t('article.notices.max_limit')
          end
        end

        context "for legal entities" do
          let(:user) { FactoryGirl.create :legal_entity }

          it "should have the default maximum for value of goods" do
            user.max_value_of_goods_cents.should eq 5000000
          end

          it "should fail to activate an article, if the value of goods crosses its max limit" do
            article = FactoryGirl.create :article, :user_id => user.id
            article.update_attribute(:price_cents, 5100000)
            article2 = FactoryGirl.create :preview_article, :user_id => user.id
            login_as user
            visit article_path(article2)
            click_button I18n.t("article.labels.submit")
            page.should have_content I18n.t('article.notices.max_limit')
          end
        end
      end
    end

    describe "article search", search: true do
      before(:each) do
        visit root_path
        fill_in 'search_input', with: 'chunky bacon'
      end

      it "should show the page with search results" do
        FactoryGirl.create :article, title: 'chunky bacon'
        Article.index.refresh

        click_button 'Suche'
        page.should have_link 'chunky bacon'
      end

      it "should rescue an Errno::ECONNREFUSED" do
        Article.any_instance.stub(:search).and_raise(Errno::ECONNREFUSED)
        expect { click_button 'Suche' }.to_not raise_error
      end

    end

    describe "article update", slow: true do
      before do
        @article = FactoryGirl.create :preview_article, seller: user
        visit edit_article_path @article
      end

      it "should succeed and redirect" do
        fill_in 'article_title', with: 'foobar'
        click_button I18n.t 'article.labels.continue_to_preview'

        @article.reload.title.should eq 'foobar'
        current_path.should eq article_path @article
      end

      it "should change the transaction when quantity was changes from one to many" do
        @article.business_transaction.should be_a SingleFixedPriceTransaction

        fill_in 'article_quantity', with: 2
        click_button I18n.t 'article.labels.continue_to_preview'

        @article.reload.business_transaction.should be_a MultipleFixedPriceTransaction

        visit edit_article_path @article
        fill_in 'article_quantity', with: 1
        click_button I18n.t 'article.labels.continue_to_preview'

        @article.reload.business_transaction.should be_a SingleFixedPriceTransaction
      end

      it "should fail given invalid data but still try to save images" do
        ArticlesController.any_instance.should_receive(:save_images).and_call_original
        Image.any_instance.should_receive(:save).twice
        old_title = @article.title

        fill_in 'article_title', with: ''
        click_button I18n.t 'article.labels.continue_to_preview'

        @article.reload.title.should eq old_title
      end
    end
    describe "article reporting" do
      before do
        visit article_path article
      end

      it "should succeed" do
        fill_in 'feedback_text', with: 'foobar'
        click_button I18n.t 'article.actions.report'

        page.should have_content I18n.t 'article.actions.reported'
      end

      it "should fail with an empty report text" do
        fill_in 'feedback_text', with: ''
        click_button I18n.t 'article.actions.report'

        page.should have_content I18n.t 'activerecord.errors.models.feedback.attributes.text.blank'

      end
    end

    describe 'contacting sellers' do
      before do
        visit article_path FactoryGirl.create :article, :with_private_user
      end

      it "should send an email when fields are filled correctly" do
        fill_in 'contact[text]', with: 'foobar'
        click_button I18n.t('article.show.contact.action')

        page.should have_content I18n.t 'article.show.contact.success_notice'
      end

      it "should fail when transmitting the user's email wasn't accepted" do
        fill_in 'contact[text]', with: 'foobar'
        uncheck 'contact[email_transfer_accepted]'
        click_button I18n.t('article.show.contact.action')

        page.should have_content I18n.t 'article.show.contact.acceptance_error'
      end

      it "should fail when the text is empty" do
        fill_in 'contact[text]', with: ''
        click_button I18n.t('article.show.contact.action')

        page.should have_content I18n.t 'article.show.contact.empty_error'
      end

      # should also fail when more than 2000 characters are entered in text

      # should save text in session
    end

    describe "the article view" do

      it "should show a buy button that immediately forwards to the transaction page" do
        visit article_path article
        click_link I18n.t 'common.actions.to_cart'
        current_path.should eq edit_business_transaction_path article.business_transaction
      end

      it "should not show a deleted LibraryElement after article deactivation" do
        seller = user
        buyer = FactoryGirl.create :buyer
        lib = FactoryGirl.create :library, :user => buyer, :public => true
        FactoryGirl.create :library_element, :article => article_active, :library => lib

        login_as seller, scope: :user
        visit article_path article_active
        click_button I18n.t 'article.labels.deactivate'

        login_as buyer, scope: :user
        visit user_libraries_path buyer
        within("#library"+lib.id.to_s) do
          page.should have_content I18n.t 'library.no_products'
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

    describe "the article view" do

      before do
        @seller = FactoryGirl.create :user
         @article_conventional = FactoryGirl.create :no_second_hand_article, :seller => @seller
      end

      it "should show fair-alternativebox if seller is not on the whitelist" do
          $exceptions_on_fairnopoly['no_fair_alternative']['user_ids'] = []
          visit article_path @article_conventional
           page.assert_selector('div.fair_alternative')

       end

     it  "should not show fair-alternativebox if seller is on the whitelist" do
          $exceptions_on_fairnopoly['no_fair_alternative']['user_ids'] = [@seller.id]
          visit article_path @article_conventional
          page.assert_no_selector('div.fair_alternative')
      end

      it "should be accessible" do
        visit article_path article
        page.status_code.should be 200
      end

      it "should rescue ECONNREFUSED errors" do
        Article.stub(:search).and_raise(Errno::ECONNREFUSED)
        $exceptions_on_fairnopoly['no_fair_alternative']['user_ids'] = []
        visit article_path article
        if article.is_conventional?
          page.should have_content I18n.t 'article.show.no_alternative'
        end
      end

      it "should display a buy button that forces a login" do #! will change after sprint
        visit article_path article
        click_link I18n.t 'common.actions.to_cart'
        page.should have_button I18n.t 'formtastic.actions.login'
      end


      it "should have a link to Transparency International" do
        visit article_path article
        page.should have_link("Transparency International", :href => "http://www.transparency.de/")
      end

      describe "-> 'other articles of this seller'-box", :search => true do
        before do
           Article.stub(:search).and_return( Kaminari.paginate_array([article_active]).page(1))
           visit article_path article_active
        end

        it "should show an active article" do
          page.should have_link('', href: article_path(article_active))
        end

        it "should not show a locked article" do
          page.should have_no_link('', href: article_path(article_locked))
        end
      end


    end
  end
end

describe "Article feature label buttons" do
  before do
    @seller = FactoryGirl.create :user
    @article = FactoryGirl.create :article, :simple_ecologic, :seller => @seller
  end

  describe "on the article show page" do
    it "should have a ecological feature label link" do
      visit article_path(@article)
      page.should have_link(I18n.t 'formtastic.labels.article.ecologic')
    end
  end

  describe "on the user show page" do
    it "should have a ecological feature label link" do
      visit user_path(@seller)
      page.should have_link(I18n.t 'formtastic.labels.article.ecologic')
    end
  end
end
