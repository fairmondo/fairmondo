#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

describe ApplicationHelper do
  describe '#crowdfunding_progress_hue' do
    it 'should be 0 for an amount of 0' do
      assert_equal 0, crowdfunding_progress_hue(0)
    end

    it 'should be 120 for a progress of 100.000' do
      assert_equal 120, crowdfunding_progress_hue(100_000)
    end
  end

  describe '#crowdfunding_progress_percentage' do
    it 'should be 0 for an amount of 0' do
      assert_equal 0.0, crowdfunding_progress_percentage(0)
    end

    it 'should be 25 for an amount of 25.000' do
      assert_equal 25.0, crowdfunding_progress_percentage(25_000)
    end
  end
end
