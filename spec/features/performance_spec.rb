### This is kind of a special integration test group.
###
### Since our test suite also noitces performance issues via the bullet gem
### we need tests that specifically trigger n+1 issues.

require 'spec_helper'

include Warden::Test::Helpers

describe 'Performance' do
  include CategorySeedData

  describe "Article#index", search: true do
    before do
      3.times { FactoryGirl.create(:article, :with_fixture_image) }
      Sunspot.commit
    end
    it "should succeed" do
      visit articles_path
      page.status_code.should be 200
    end
  end

  describe "Article#new" do
    it "should succeed" do
      # Does not yet trigger n+1
      pending
      setup_categories
      visit new_article_path
      page.status_code.should be 200
    end
  end
end
