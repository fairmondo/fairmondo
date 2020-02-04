#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class FeaturedLibraryQueryTest < ActiveSupport::TestCase
  describe '#find' do
    it 'finds featured library elements and fills them if need be' do
      library = create :library, :public, exhibition_name: :queue1
      non_featured_element = create :library_element, library: library, exhibition_date: nil
      newer_featured_element = create :library_element, library: library, exhibition_date: DateTime.now + 6.hours
      older_featured_element = create :library_element, library: library, exhibition_date: DateTime.now, article: create(:article, created_at: DateTime.now - 1.day)

      result = FeaturedLibraryQuery.new(:queue1).find(2)
      result.must_equal library: library, exhibits: [older_featured_element.article, newer_featured_element.article]

      # Time passes ...
      tomorrow = DateTime.now + 1.day
      DateTime.stubs(:now).returns(tomorrow)
      # The next day arrives. The old article has been exhibited for more than 24 hours. the newer article still has a few hours to go.

      result = FeaturedLibraryQuery.new.set(:queue1).find(2) # set does the same thing as #new with argument
      result.must_equal library: library, exhibits: [newer_featured_element.article, non_featured_element.article]
      non_featured_element.reload.exhibition_date.wont_be_nil

      # Time passes ...
      day_after_tomorrow = tomorrow + 1.day
      DateTime.stubs(:now).returns(day_after_tomorrow)
      # Now only the (not anymore correctly named) non_featured_element should be featured and the queue should be filled with an article that was already featured before.

      result = FeaturedLibraryQuery.new(:queue1).find(2) # set does the same thing as #new with argument
      result[:exhibits][0].must_equal non_featured_element.article
      [older_featured_element.article, newer_featured_element.article].must_include result[:exhibits][1] # one of the 2, it's randomized
    end
  end
end
