#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

feature 'Advent calendar' do
  scenario 'User visits in the middle of November and finds no calendar' do
    travel_to Time.new(2015, 11, 15) do
      visit root_path
      refute page.has_selector?('.advent-calendar')
    end
  end

  scenario 'User visits on the 24th of November and finds the pre-calendar widget' do
    travel_to Time.new(2015, 11, 24) do
      visit root_path
      within '.advent-calendar' do
        assert page.has_selector?('.advent-calendar-pre')
      end
    end
  end

  scenario 'User visits on the 5th of December and finds the calendar' do
    travel_to Time.new(2015, 12, 5, 9) do
      visit root_path
      within '.advent-calendar' do
        assert page.has_selector?('.advent-calendar-05')
      end
    end
  end

  scenario 'User visits on the 6th of December and finds a different calendar' do
    travel_to Time.new(2015, 12, 6, 9) do
      visit root_path
      within '.advent-calendar' do
        assert page.has_selector?('.advent-calendar-06')
      end
    end
  end
end
