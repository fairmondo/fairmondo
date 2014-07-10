require_relative '../test_helper'

include Warden::Test::Helpers

feature 'Adding an Article to the cart' do

  setup do
    @article = FactoryGirl.create(:article, title: 'foobar')
  end

  scenario 'anonymous user adds articles to his cart' do
    visit article_path(@article)
    click_button 'common.actions.to_cart'
    click_link 'header.cart'
    page.must_have_content 'foobar'
  end

  scenario 'logged-in user adds articles to his cart' do
    login_as FactoryGirl.create(:user)
    visit article_path(@article)
    click_button 'common.actions.to_cart'
    click_link 'header.cart'
    page.must_have_content 'foobar'
  end

end


