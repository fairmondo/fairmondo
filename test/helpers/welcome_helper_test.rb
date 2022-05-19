#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class WelcomeHelperTest < ActionView::TestCase
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
    describe '#calendar_time?' do
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
    end

    describe '#calendar_window_num' do
      it 'considers the calendar window number to be 4 on the 5th Dec at 8:59' do
        travel_to Time.new(2015, 12, 05, 8, 59) do
          assert_equal(4, calendar_window_num)
        end
      end

      it 'considers the calendar window number to be 5 on the 5th Dec at 9 o\' clock' do
        travel_to Time.new(2015, 12, 05, 9) do
          assert_equal(5, calendar_window_num)
        end
      end

      it 'considers the calendar window number to be 0 on the 1st Dec at 8:59' do
        travel_to Time.new(2015, 12, 01, 8, 59) do
          assert_equal(0, calendar_window_num)
        end
      end

      it 'considers the calendar window number to be 0 before the 1st Dec' do
        travel_to Time.new(2015, 11, 27) do
          assert_equal(0, calendar_window_num)
        end
      end

      it 'considers the calendar window number to be 24 on the 25th Dec at 9 o\' clock' do
        travel_to Time.new(2015, 12, 25, 9) do
          assert_equal(24, calendar_window_num)
        end
      end

      it 'considers the calendar window number to be 24 after the 25th Dec' do
        travel_to Time.new(2015, 12, 27) do
          assert_equal(24, calendar_window_num)
        end
      end
    end

    describe '#calendar_window_link' do
      it 'returns a different link for two distinct calendar window numbers' do
        refute_equal calendar_window_link(5), calendar_window_link(6)
      end

      it 'returns links for edge cases' do
        refute_nil calendar_window_link(0)
        refute_nil calendar_window_link(24)
      end
    end
  end
end
