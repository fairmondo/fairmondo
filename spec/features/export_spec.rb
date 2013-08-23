require 'spec_helper'

include Warden::Test::Helpers
include CategorySeedData

describe "Export" do

  let (:private_user) { FactoryGirl.create :private_user }
  let (:legal_entity_user) { FactoryGirl.create :legal_entity, :paypal_data }

  subject { page }

  context "for signed-in private users" do
    before do
      login_as private_user
      visit user_path(private_user)
    end

    it "should not have a export link" do
      should_not have_button I18n.t('mass_upload.labels.upload_article')
    end
  end


  describe "for signed-in legal entity users" do

    before do
      setup_categories
      login_as legal_entity_user
      # visit new_mass_upload_path
      # attach_file('mass_upload_file',
      #             'spec/fixtures/mass_upload_correct.csv')
      # click_button I18n.t('mass_upload.labels.upload_article')
      # debugger
      # visit user_path(legal_entity_user)
    end

    it "should create new articles" do
      visit new_article_path
      # visit new_mass_upload_path
      # debugger
      attach_file('mass_upload_file',
                  'spec/fixtures/mass_upload_correct.csv')
      should have_button I18n.t('mass_upload.labels.upload_article')
      # click_button I18n.t('mass_upload.labels.upload_article')
      expect { click_button I18n.t('mass_upload.labels.upload_article') }
                .to change(Article, :count).by(2)
      visit user_path(legal_entity_user)
      # save_and_open_page
      should have_link(I18n.t('users.boxes.export'))
      should have_link(I18n.t('articles.export.all'))
    end

    # it "should have a csv upload link" do
    #   should have_link(I18n.t('users.boxes.export'))
    #   should have_link(I18n.t('articles.export.all'))
    # end

    # describe "clicking export all articles" do
    #   before do
    #     click_link I18n.t('articles.export.all')
    #     debugger
    #   end

    #   it "should have a response body" do
    #     should have_link(I18n.t('users.boxes.export'))
    #   end
    # end
  end
end