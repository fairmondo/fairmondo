require 'spec_helper'

include Warden::Test::Helpers


describe "Mass-upload" do

  let(:private_user) { FactoryGirl.create :private_user }
  let(:legal_entity_user) { FactoryGirl.create :legal_entity }

  subject { page }

  describe "for code-coverage purposes of sidekiq retries" do
    it "should cover exhausted upload workers" do
      Sidekiq.logger.stub(:warn)
      ProcessMassUploadWorker.sidekiq_retries_exhausted_block.call({"class" => Object.class , "args" => {}, "error_message" => ""})
    end
    it "should cover exhausted row workers" do
      Sidekiq.logger.stub(:warn)
      mu = FactoryGirl.create :mass_upload
      ProcessRowMassUploadWorker.sidekiq_retries_exhausted_block.call({"class" => Object.class , "args" => [mu.id,"lala",3], "error_message" => "snafu"})
    end
  end

  context "for non signed-in users" do
    it "should rediret to login page" do
      visit new_mass_upload_path
      current_path.should eq new_user_session_path
      should have_selector(:link_or_button, 'Login')
    end
  end

  context "for signed-in private users" do
    let(:legal_entity_user) { FactoryGirl.create :legal_entity,
                              :missing_bank_data }
    before do
      login_as private_user
      visit new_article_path
    end

    it "should not have a csv upload link" do
      should_not have_link(I18n.t('users.boxes.import'),
                           href: new_mass_upload_path
      )
    end
  end


  context "for signed-in legal entity users" do

    before do
      login_as legal_entity_user
    end

    it "should have a csv upload link" do
      visit new_article_path
      should have_link(I18n.t('users.boxes.import'))
    end

    describe "when uploading" do
      before do
        visit new_mass_upload_path
      end

      context "as a user with complete payment data" do
        let(:legal_entity_user) { FactoryGirl.create :legal_entity,
                                    :paypal_data }

        context "and a valid csv file" do
          context "when action is create" do
            before do
              attach_file('mass_upload_file',
                         'spec/fixtures/mass_upload_correct.csv')
            end

            it "should redirect to the mass_uploads#show", visual: true do
              click_button I18n.t('mass_uploads.labels.upload_article')
              should have_content I18n.t('users.boxes.my_mass_uploads')
              click_link I18n.t('mass_uploads.labels.show_report')
              should have_content('Name von Artikel 1')
              should have_selector('input.Btn.Btn--blue.Btn--blueBig',
                            I18n.t('mass_uploads.labels.mass_activate_articles'))
            end

            it "should create new articles" do
              expect { click_button I18n.t('mass_uploads.labels.upload_article') }
                        .to change(Article, :count).by(3)
            end

            describe "activate articles" do
              before do
                click_button I18n.t('mass_uploads.labels.upload_article')
                click_link I18n.t("mass_uploads.labels.show_report")
              end

              it "should redirect to user#offers when activating all articles" do
                click_button I18n.t('mass_uploads.labels.mass_activate_articles')
                should_not have_selector('h1',
                            text: I18n.t('mass_uploads.titles.uploaded_articles'))
                should have_selector('a', text: Article.last.title)
              end

              it "going back to mass_uploads#show it should show changed buttons" do
                last_path = current_path.dup
                click_button I18n.t('mass_uploads.labels.mass_activate_articles')
                visit last_path
                should_not have_selector('input.Btn.Btn--green.Btn--greenSmall')
                should have_content I18n.t(
                                    'mass_uploads.labels.all_articles_activated')
              end
            end
          end

          context "when the action updates an article" do
            context "with a valid request" do
              context "via 'update'" do
                it "should update all requested articles" do
                  # create articles
                  attach_file('mass_upload_file',
                             'spec/fixtures/mass_upload_correct.csv')
                  click_button I18n.t('mass_uploads.labels.upload_article')
                  click_link I18n.t("mass_uploads.labels.show_report")
                  click_button I18n.t('mass_uploads.labels.mass_activate_articles')

                  # change them
                  visit new_mass_upload_path
                  attach_file('mass_upload_file', 'spec/fixtures/mass_update_correct.csv')
                  click_button I18n.t('mass_uploads.labels.upload_article')
                  first(:link, I18n.t("mass_uploads.labels.show_report")).click
                  click_button I18n.t('mass_uploads.labels.mass_activate_articles')

                  # validate changes
                  article1 = Article.find(4) # as it will edit them both as new
                  article2 = Article.find(5)
                  article1.content.should eq 'Andere Beschreibung'
                  article1.condition.should eq 'old'
                  article2.title.should eq 'Anderer Name'
                  article2.gtin.should eq "9999999999"
                  article1.active?.should eq true
                  article2.active?.should eq true
                  Article.find(1).closed?.should eq true
                  Article.find(2).closed?.should eq true
                  Article.find(3).title.should eq "Name von Artikel 3"
                end
              end

              context "via 'delete'" do
                it "should delete requested articles" do
                  FactoryGirl.create :article, :seller => legal_entity_user
                  FactoryGirl.create :article, :custom_seller_identifier => "abc123", :seller => legal_entity_user
                  attach_file('mass_upload_file',
                             'spec/fixtures/mass_delete.csv')
                  click_button I18n.t('mass_uploads.labels.upload_article')
                  Article.find(1).closed?.should eq true
                  Article.find(2).closed?.should eq true
                end

                it "should throw an error when the requested ID is already deleted" do
                  article = FactoryGirl.create :closed_article, :seller => legal_entity_user

                  attach_file('mass_upload_file',
                               'spec/fixtures/mass_upload_single_delete.csv')
                  click_button I18n.t('mass_uploads.labels.upload_article')
                  click_link I18n.t("mass_uploads.labels.show_report")

                  page.should have_content I18n.t('mass_uploads.boxes.deleted')
                  page.should have_content article.title
                end
              end

              context "via 'activate'" do
                it "should activate requested articles" do
                  FactoryGirl.create :preview_article, :seller => legal_entity_user
                  FactoryGirl.create :preview_article, :custom_seller_identifier => "abc123", :seller => legal_entity_user
                  attach_file('mass_upload_file',
                             'spec/fixtures/mass_activate.csv')
                  click_button I18n.t('mass_uploads.labels.upload_article')
                  click_link I18n.t("mass_uploads.labels.show_report")
                  click_button I18n.t('mass_uploads.labels.mass_activate_articles')
                  Article.find(1).active?.should eq true
                  Article.find(2).active?.should eq true
                end
              end

              context "via 'deactivate'" do
                it "should deactivate requested articles" do
                  FactoryGirl.create :article, :seller => legal_entity_user
                  FactoryGirl.create :article, :custom_seller_identifier => "abc123", :seller => legal_entity_user
                  attach_file('mass_upload_file',
                             'spec/fixtures/mass_deactivate.csv')
                  click_button I18n.t('mass_uploads.labels.upload_article')
                  Article.find(1).locked?.should eq true
                  Article.find(2).locked?.should eq true
                end
              end
            end

            context "with an invalid request" do
              it "should throw an 'article not found' error when the requested ID doesn't belong to the current user" do
                FactoryGirl.create :article

                attach_file('mass_upload_file',
                             'spec/fixtures/mass_upload_single_delete.csv')
                click_button I18n.t('mass_uploads.labels.upload_article')
                click_link I18n.t("mass_uploads.labels.show_report")

                page.should have_content I18n.t('mass_uploads.errors.article_not_found')
                Article.find(1).closed?.should eq false
              end

              it "should throw an error when the requested ID doesn't exist" do
                  attach_file('mass_upload_file',
                             'spec/fixtures/mass_deactivate.csv')
                  click_button I18n.t('mass_uploads.labels.upload_article')
                  click_link I18n.t("mass_uploads.labels.show_report")
                  should have_content(I18n.t('mass_uploads.errors.article_not_found'))
              end

              it "should throw an error when no ID or custom_seller_id was given" do
                attach_file('mass_upload_file',
                             'spec/fixtures/mass_activate_without_id.csv')
                  click_button I18n.t('mass_uploads.labels.upload_article')
                  click_link I18n.t("mass_uploads.labels.show_report")
                  should have_content(I18n.t('mass_uploads.errors.no_identifier'))
              end
            end
          end

          context "when action is empty" do

            # The standard mass_upload test case fixes this already
            #it "should create an article when no ID was given" do
            #  pending 'coming soon'
            #end

            it "should do nothing with the article when an ID was given" do
              FactoryGirl.create :article, :seller => legal_entity_user
                  attach_file('mass_upload_file',
                             'spec/fixtures/mass_upload_without_action.csv')
                  click_button I18n.t('mass_uploads.labels.upload_article')
                  Article.unscoped.size.should be 1
            end
          end

          context "when different existing actions were given" do
            it "should create, update, or delete the respective article" do
              a1 = FactoryGirl.create :article, :seller => legal_entity_user
              a2 = FactoryGirl.create :preview_article, :seller => legal_entity_user
              a3 = FactoryGirl.create :article, :seller => legal_entity_user
              a4 = FactoryGirl.create :article, :without_image, :seller => legal_entity_user # problems with dup and images while testing
              a5 = FactoryGirl.create :preview_article, :seller => legal_entity_user
                  attach_file('mass_upload_file',
                             'spec/fixtures/mass_upload_correct_multiple_action.csv')
                  click_button I18n.t('mass_uploads.labels.upload_article')
                  click_link I18n.t("mass_uploads.labels.show_report")

                  click_button I18n.t('mass_uploads.labels.mass_activate_articles')
                  a1.reload.closed?.should be true
                  a2.reload.active?.should be true
                  a3.reload.locked?.should be true
                  a4.reload.closed?.should be true # because of edit as new
                  a5.reload.active?.should be true # because this was a preview article
                  Article.unscoped.size.should be 9 # 5 created by factory, 3 createdby csv
                  Article.unscoped.where(:title => "neuer titel").size.should be 2 # the closed one and the open one
            end
          end

          context "when a non-existant action was given" do
            it "should throw an error" do
              FactoryGirl.create :article, :seller => legal_entity_user

              attach_file('mass_upload_file',
                         'spec/fixtures/mass_upload_wrong_action.csv')
              click_button I18n.t('mass_uploads.labels.upload_article')
              click_link I18n.t("mass_uploads.labels.show_report")

              page.should have_content I18n.t('mass_uploads.errors.unknown_action')
            end
          end
        end

        context "(invalid file:" do

          describe "csv, wrong articles)" do
            before { attach_file('mass_upload_file',
                        'spec/fixtures/mass_upload_wrong_article.csv') }

            it "should show correct error messages" do
              click_button I18n.t('mass_uploads.labels.upload_article')
              click_link I18n.t("mass_uploads.labels.show_report")
              should have_content(I18n.t('mass_uploads.errors.wrong_article_message'))
            end

            it "should not create new articles" do
              expect { click_button I18n.t('mass_uploads.labels.upload_article') }
                      .not_to change(Article, :count)
            end
          end

          describe "wrong encoding)" do
            it "should show correct error messages" do
              attach_file('mass_upload_file',
                          'spec/fixtures/mass_upload_wrong_encoding.csv')
              click_button I18n.t('mass_uploads.labels.upload_article')
              should have_content(I18n.t('mass_uploads.errors.wrong_encoding'))
            end
          end

          describe "illegal-quoting)" do
            it "should show correct error messages" do
              attach_file('mass_upload_file',
                          'spec/fixtures/mass_upload_illegal_quoting.csv')
              click_button I18n.t('mass_uploads.labels.upload_article')
              should have_content(I18n.t('mass_uploads.errors.illegal_quoting'))
            end
          end


        end
      end
    end
  end
end