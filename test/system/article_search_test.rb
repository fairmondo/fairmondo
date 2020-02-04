#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'application_system_test_case'

class ArticleSearchTest < ApplicationSystemTestCase
  test 'should show the page with search results' do
    ArticlesIndex.reset!
    visit root_path
    fill_in 'search_input', with: 'chunky bacon'
    create :article, :index_article, title: 'chunky bacon'

    click_button 'Suche'
    page.must_have_link 'chunky bacon'
  end

  test 'elastic search server disconnects' do
    Chewy::Query.any_instance.stubs(:to_a).raises(Faraday::ConnectionFailed.new('test')) # simulate connection error so that we dont have to use elastic
    visit root_path
    click_button 'Suche'
  end
end
