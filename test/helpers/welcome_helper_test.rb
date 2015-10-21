#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

describe WelcomeHelper do
  describe '#rss_image_extractor' do
    it 'returns an image when there is one' do
      content = "<p><img src=\"test.png\"/>"
      result = ' <img src="test.png"> '
      additional = ' test test'
      helper.rss_image_extractor(content + additional).must_equal result
    end
    it 'returns empty string with no image present' do
      content = '<p> testt test</p>'
      helper.rss_image_extractor(content).must_equal ''
    end
  end

  describe 'advent calendar' do
    it 'is calendar time between Nov 24th and Dec 24th' do
      travel_to Time.new(2015, 11, 24) do
        assert(calendar_time?)
      end
      travel_to Time.new(2015, 12, 24) do
        assert(calendar_time?)
      end
    end

    it 'is not calendar time outside of this time zone' do
      travel_to Time.new(2015, 11, 23) do
        refute(calendar_time?)
      end
      travel_to Time.new(2015, 12, 25) do
        refute(calendar_time?)
      end
    end

    it 'finds the right calendar partial according to the date' do
      travel_to Time.new(2015, 12, 05) do
        assert_equal('welcome/advent_calendar/window_05', calendar_partial_name)
      end
    end

    it 'before December finds the pre-calendar partial' do
      travel_to Time.new(2015, 11, 27) do
        assert_equal('welcome/advent_calendar/window_pre', calendar_partial_name)
      end
    end
  end
end
