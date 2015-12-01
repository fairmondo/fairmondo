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
    it 'is calendar time between Nov 24th and Dec 25th, 9:00' do
      travel_to Time.new(2015, 11, 24) do
        assert(calendar_time?)
      end
      travel_to Time.new(2015, 12, 25, 9) do
        assert(calendar_time?)
      end
    end

    it 'is not calendar time outside of this time zone' do
      travel_to Time.new(2015, 11, 23) do
        refute(calendar_time?)
      end
      travel_to Time.new(2015, 12, 25, 9, 1) do
        refute(calendar_time?)
      end
    end

    it 'shows the calendar partial for the 4th on the 5th at 8:59' do
      travel_to Time.new(2015, 12, 05, 8, 59) do
        assert_equal('welcome/advent_calendar/window_04', calendar_partial_name)
      end
    end

    it 'shows the calendar partial for the 5th on the 5th at 9 o\' clock' do
      travel_to Time.new(2015, 12, 05, 9) do
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
