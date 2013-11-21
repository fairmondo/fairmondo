require 'spec_helper'

include Warden::Test::Helpers
include CategorySeedData

describe "Export" do

  let(:private_user)       { FactoryGirl.create :private_user }
  let(:legal_entity)       { FactoryGirl.create :legal_entity, :paypal_data }
  # legal_entity = FactoryGirl.create :legal_entity, :paypal_data

  let(:legal_entity_buyer) { FactoryGirl.create :legal_entity }

  subject { page }

  describe "for signed-in private users" do
    before do
      login_as private_user
      visit user_path(private_user)
    end

    it "should not have a export link" do
      should_not have_link I18n.t('articles.export.inactive')
    end
  end

  describe "for signed-in legal entity users" do

    before do
      setup_categories
      login_as legal_entity
      visit new_mass_upload_path
    end

    describe "dealing with a fair_trust article" do

      before do
        attach_file('mass_upload_file',
                    'spec/fixtures/mass_upload_correct_upload_export_test.csv')
        click_button I18n.t('mass_uploads.labels.upload_article')
      end

      describe "visting the new_article_path" do
        before do
          visit user_path(legal_entity)
        end

        it "should have a export link" do
          should have_link I18n.t('articles.export.inactive')
        end
      end

      describe "when exporting inactive articles" do

        it "should be equal to the uploaded file" do
          @csv = Article::Export.export_articles(legal_entity, "inactive")
          @csv.should == File.read('spec/fixtures/mass_upload_correct_export_test.csv')
        end
      end

      describe "when exporting active articles" do
        before do
          click_link I18n.t('mass_uploads.labels.show_report')
          click_button I18n.t('mass_uploads.labels.mass_activate_articles')
        end

        it "should be equal to the uploaded file" do
          @csv = Article::Export.export_articles(legal_entity, "active")
          @csv.should == File.read('spec/fixtures/mass_upload_correct_export_test.csv')
        end
      end

      describe "when exporting (fair_trust)" do
        before do
          click_link I18n.t('mass_uploads.labels.show_report')
          click_button I18n.t('mass_uploads.labels.mass_activate_articles')
          @transaction = FactoryGirl.create :single_transaction, :sold, article: legal_entity.articles.last, :buyer => legal_entity_buyer
          @article = legal_entity.articles.last
          @article.update_attribute :state, 'sold'
          visit user_path(legal_entity)
        end

        describe "a sold article" do
          before { visit user_path(legal_entity) }

          it "should have a export link" do
            should have_link I18n.t('articles.export.sold')
          end

          it "should be equal to the uploaded file" do
            @csv = Article::Export.export_articles(legal_entity, "sold")
            @csv.should == File.read('spec/fixtures/mass_upload_correct_export_test.csv')
          end
        end

        describe "a bought article" do
          before do
            login_as legal_entity_buyer
            visit user_path(legal_entity_buyer)
          end

          it "should have a export link" do
            should have_link I18n.t('articles.export.bought')
          end

          it "should be equal to the uploaded file" do
            @csv = Article::Export.export_articles(legal_entity_buyer, "bought")
            @csv.should == File.read('spec/fixtures/mass_upload_correct_export_test.csv')
          end
        end
      end
    end

    describe "dealing with a fair_trust article" do

      before do
        attach_file('mass_upload_file',
                    'spec/fixtures/export_upload_social_producer.csv')
        click_button I18n.t('mass_uploads.labels.upload_article')
      end

      describe "when exporting inactive articles" do

        it "should be equal to the uploaded file" do
          @csv = Article::Export.export_articles(legal_entity, "inactive")
          @csv.should == File.read('spec/fixtures/export_social_producer.csv')
        end
      end
    end
  end
end