require_relative '../test_helper'

include Warden::Test::Helpers

feature "CMS System" do
  let(:content) { FactoryGirl.create :content }
  let(:admin) { FactoryGirl.create :admin_user }

  scenario "user visits an existing page" do
    visit content_path content
    page.must_have_content content.body
  end

  scenario "admin visists a non exsisting page" do
    login_as admin
    visit content_path 'not-there'
    current_path.must_equal new_content_path

  end
  scenario "guest visit non exsisting page" do
    -> { visit content_path 'not-there' }.must_raise ActiveRecord::RecordNotFound
  end

  scenario "admin visits content index" do
    login_as admin
    visit contents_path
    current_path.must_equal contents_path
  end

  scenario "guest visits content index" do
    visit contents_path
    current_path.must_equal new_user_session_path
  end

  scenario 'admin creates content' do
    login_as admin
    visit new_content_path

    fill_in 'content_key', with: 'foobar'
    fill_in 'content_body', with: 'Bazfuz'

    assert_difference 'Content.count', 1 do
      click_button I18n.t 'helpers.submit.create', model: (I18n.t 'activerecord.models.content.one')
    end

    page.must_have_content 'CMS-Seite wurde erstellt.'
    page.must_have_content 'Bazfuz'
  end

  scenario 'admin updates content' do
    login_as admin
    visit edit_content_path content
    fill_in 'content_key', with: 'foobar'
    fill_in 'content_body', with: 'Bazfuz'
    click_button I18n.t 'helpers.submit.update', model: (I18n.t 'activerecord.models.content.one')
    page.must_have_content 'CMS-Seite wurde aktualisiert.'
    page.must_have_content 'Bazfuz'
  end

  scenario 'admin deletes content' do
    login_as admin
    content
    visit contents_path
    assert_difference 'Content.count', -1 do
      click_link 'Destroy'
    end
  end
end
