require 'spec_helper'

include Warden::Test::Helpers
include CategorySeedData

describe "Export" do

  let(:private_user)       { FactoryGirl.create :private_user }
  let(:legal_entity)       { FactoryGirl.create :legal_entity, :paypal_data }
  let(:legal_entity_buyer) { FactoryGirl.create :legal_entity, :email => "hans@dampf.de" }

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
          IO.read(@csv).should == IO.read('spec/fixtures/mass_upload_export.csv')
        end
      end

      describe "when exporting active articles" do
        before do
          click_link I18n.t('mass_uploads.labels.show_report')
          click_button I18n.t('mass_uploads.labels.mass_activate_articles')
        end

        it "should be equal to the uploaded file" do
          @csv = Article::Export.export_articles(legal_entity, "active")
          IO.read(@csv).should == IO.read('spec/fixtures/mass_upload_export.csv')
        end
      end
    end

    describe "when exporting multiple (fair_trust)" do
      before do
        attach_file('mass_upload_file',
                    'spec/fixtures/mass_upload_multiple.csv')
        click_button I18n.t('mass_uploads.labels.upload_article')
        click_link I18n.t('mass_uploads.labels.show_report')
        click_button I18n.t('mass_uploads.labels.mass_activate_articles')
        @transaction1 = FactoryGirl.create :single_transaction, :sold,
                                          article: legal_entity.articles.last,
                                          :buyer => legal_entity_buyer,
                                          forename: "Hans", surname: "Dampf",
                                          street: "In allen Gassen 1",
                                          city: "Berlin", zip: "10999",
                                          sold_at: "2013-12-03 17:50:15"

        legal_entity.articles.last.update_attribute :state, 'sold'
        visit user_path(legal_entity)
      end

      describe "sold articles" do
        before { visit user_path(legal_entity) }

        it "should have a export link" do
          should have_link I18n.t('articles.export.sold')
        end

        it "should be equal to the test file" do

          @transaction2 = FactoryGirl.create :single_transaction, :sold,
                                            article: legal_entity.articles[1],
                                            selected_transport: 'type2',
                                            :buyer => legal_entity_buyer,
                                            forename: "Hans", surname: "Dampf",
                                            street: "In allen Gassen 1",
                                            city: "Berlin", zip: "10999",
                                            sold_at: "2013-12-03 17:50:15"
          @transaction3 = FactoryGirl.create :single_transaction, :sold,
                                            article: legal_entity.articles.first,
                                            selected_transport: 'type1',
                                            :buyer => legal_entity_buyer,
                                            forename: "Hans", surname: "Dampf",
                                            street: "In allen Gassen 1",
                                            city: "Berlin", zip: "10999",
                                            sold_at: "2013-12-03 17:50:15"
          legal_entity.articles.each { |article| article.update_attribute(:state, 'sold') }
          @csv = Article::Export.export_articles(legal_entity, "sold")
          IO.read(@csv).should == IO.read('spec/fixtures/mass_upload_correct_export_test_sold.csv')
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
          IO.read(@csv).should == IO.read('spec/fixtures/mass_upload_export_bought.csv')
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
          IO.read(@csv).should == IO.read('spec/fixtures/export_social_producer.csv')
        end
      end
    end

    describe "dealing with wrong articles" do

      before do
        attach_file('mass_upload_file',
                    'spec/fixtures/mass_upload_wrong_article.csv')
        click_button I18n.t('mass_uploads.labels.upload_article')
      end

      describe "when exporting failed articles" do

        it "should be equal to the uploaded file" do
          @csv = Article::Export.export_erroneous_articles(MassUpload.last.erroneous_articles)
          IO.read(@csv).should == IO.read('spec/fixtures/mass_upload_wrong_article.csv')
        end
      end
    end
  end
end