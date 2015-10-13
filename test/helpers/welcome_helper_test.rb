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
end
