require 'spec_helper'

include Warden::Test::Helpers
include CategorySeedData

describe "Export" do

  let (:private_user) { FactoryGirl.create :private_user }
  let (:legal_entity) { FactoryGirl.create :legal_entity, :paypal_data }

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
      attach_file('mass_upload_file',
                  'spec/fixtures/mass_upload_correct.csv')
      click_button I18n.t('mass_upload.labels.upload_article')
    end

    describe "visting the new_article_path" do
      before do
        visit user_path(legal_entity)
      end

      it "should have a export link" do
        should have_link I18n.t('articles.export.inactive')
      end
    end

    # bugbug should this be a model spec?
    describe "when exporting inactive articles" do

      it "should be equal to the uploaded file" do
        pending "Needs work"
        @csv = Article::Export.export_articles(legal_entity)
        @csv.should eq File.read('spec/fixtures/mass_upload_correct.csv')
      end
    end

    describe "when exporting active articles" do

      it "should be equal to the uploaded file" do
        pending "Needs work"
        @csv = Article::Export.export_articles(legal_entity, "active")
        @csv.should eq File.read('spec/fixtures/mass_upload_correct.csv')
      end
    end
  end
end