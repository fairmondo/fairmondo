require 'spec_helper'

include Warden::Test::Helpers
include CategorySeedData

describe "Mass-upload" do

  let(:private_user) { FactoryGirl.create :private_user }
  let(:legal_entity_user) { FactoryGirl.create :legal_entity }

  subject { page }

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
      visit new_article_path
    end

    it "should have a csv upload link" do
      should have_link(I18n.t('users.boxes.import'))
    end

    describe "when uploading" do
      before do
        setup_categories
        visit new_mass_upload_path
      end

      describe "as a user missing paypal data -" do
        let(:legal_entity_user) { FactoryGirl.create :legal_entity }

        before do
          attach_file('mass_upload_file',
                      'spec/fixtures/mass_upload_correct.csv')
          click_button I18n.t('mass_uploads.labels.upload_article')
        end

        it "should show the correct error notice" do
          pending "*Basti*: I'm not sure what the expected behavior is here. Test fails for me. -K"
          should have_css(".Notice--error")
          html.should include(
            I18n.t('mass_uploads.errors.missing_payment_details',
                    link: '#payment_step',
                    missing_payment: I18n.t('formtastic.labels.user.paypal_account')
            )
          )
        end
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

            it "should redirect to the mass_uploads#show" do
              click_button I18n.t('mass_uploads.labels.upload_article')
              should have_content('Name von Artikel 1')
              should have_selector('input.Btn.Btn--blue.Btn--blueBig',
                            I18n.t('mass_uploads.labels.mass_activate_articles'))
            end

            it "should create new articles" do
              expect { click_button I18n.t('mass_uploads.labels.upload_article') }
                        .to change(Article, :count).by(3)
            end

            describe "activate articles" do
              before { click_button I18n.t('mass_uploads.labels.upload_article') }

              it "should redirect to user#offers when activating all articles" do
                click_button I18n.t('mass_uploads.labels.mass_activate_articles')
                should_not have_selector('h1',
                            text: I18n.t('mass_uploads.titles.uploaded_articles'))
                should have_selector('a', text: Article.last.title)
              end

              it "going back to mass_uploads#show it should show changed buttons" do
                secret_mass_uploads_number = current_path.delete "/mass_uploads/"
                click_button I18n.t('mass_uploads.labels.mass_activate_articles')
                visit mass_upload_path(secret_mass_uploads_number)
                should_not have_selector('input.Btn.Btn--green.Btn--greenSmall')
                should have_content I18n.t(
                                    'mass_uploads.labels.all_articles_activated')
              end
            end
          end

          context "when action is update" do
            it "should update all requested articles" do
              pending 'coming soon'
              # create articles
              attach_file('mass_upload_file',
                         'spec/fixtures/mass_upload_correct.csv')
              click_button I18n.t('mass_uploads.labels.upload_article')
              click_button I18n.t('mass_uploads.labels.mass_activate_articles')

              # change them
              visit new_mass_upload_path
              attach_file('mass_upload_file', 'spec/fixtures/mass_update.csv')
              click_button I18n.t('mass_uploads.labels.upload_article')

              # validate changes
              article1 = Article.find(1)
              article2 = Article.find(2)
              article1.content.should eq 'Andere Beschreibung'
              article1.condition.should eq 'old'
              article2.title.should eq 'Anderer Name'
              article2.gtin.should eq 999
            end
          end

          context "when action is delete" do
            it "should show a deletion warning" do
              pending 'coming soon'
            end

            it "should delete all requested articles" do
              pending 'coming soon'
            end
          end

          context "when action is empty" do
            it "should create an article when no ID was given" do
              pending 'coming soon'
            end

            it "should update the article when an ID was given" do
              pending 'coming soon'
            end
          end

          context "when different actions were given" do
            it "should create, update, or delete the respective article" do
              pending 'coming soon'
            end
          end
        end

        context "(invalid file:" do

          describe "csv, wrong header)" do
            before { attach_file('mass_upload_file',
                                 'spec/fixtures/mass_upload_wrong_header.csv') }

            it "should show correct error messages" do
              click_button I18n.t('mass_uploads.labels.upload_article')
              should have_selector('p.inline-errors',
                text: I18n.t('mass_uploads.errors.wrong_header'))
            end

            it "should not create new articles" do
              expect { click_button I18n.t('mass_uploads.labels.upload_article') }
                      .not_to change(Article, :count)
            end
          end

          describe "csv, wrong articles)" do
            before { attach_file('mass_upload_file',
                        'spec/fixtures/mass_upload_wrong_article.csv') }

            it "should show correct error messages" do
              click_button I18n.t('mass_uploads.labels.upload_article')
              should have_selector('p.inline-errors',
                text: I18n.t('mass_uploads.errors.wrong_article',
                  message: I18n.t('mass_uploads.errors.wrong_article_message'),
                  index: 3))
            end

            it "should not create new articles" do
              expect { click_button I18n.t('mass_uploads.labels.upload_article') }
                      .not_to change(Article, :count)
            end
          end

          describe "wrong format)" do
            it "should show correct error messages" do
              attach_file('mass_upload_file',
                          'spec/fixtures/mass_upload_wrong_format.html')
              click_button I18n.t('mass_uploads.labels.upload_article')
              should have_selector('p.inline-errors',
                text: I18n.t('mass_uploads.errors.wrong_mime_type'))
            end
          end

          describe "wrong encoding)" do
            it "should show correct error messages" do
              attach_file('mass_upload_file',
                          'spec/fixtures/mass_upload_wrong_encoding.csv')
              click_button I18n.t('mass_uploads.labels.upload_article')
              should have_selector('p.inline-errors',
                text: I18n.t('mass_uploads.errors.wrong_encoding'))
            end
          end

          describe "too many articles)" do
            it "should show correct error messages" do
              attach_file('mass_upload_file',
                          'spec/fixtures/mass_upload_to_many_articles.csv')
              click_button I18n.t('mass_uploads.labels.upload_article')
              should have_selector('p.inline-errors',
                text: I18n.t('mass_uploads.errors.wrong_file_size'))
            end
          end

          describe "illegal-quoting)" do
            it "should show correct error messages" do
              attach_file('mass_upload_file',
                          'spec/fixtures/mass_upload_illegal_quoting.csv')
              click_button I18n.t('mass_uploads.labels.upload_article')
              should have_selector('p.inline-errors',
                text: I18n.t('mass_uploads.errors.illegal_quoting'))
            end
          end

          describe "no file selected)" do
            it "should show correct error messages" do
              click_button I18n.t('mass_uploads.labels.upload_article')
              should have_selector('p.inline-errors',
                text: I18n.t('mass_uploads.errors.missing_file'))
            end
          end
        end
      end
    end
  end
end