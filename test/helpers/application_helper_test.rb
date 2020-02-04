#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  describe 'clickable_legal_links' do
    it 'should put a link around an ODR URL' do
      html = '<p>Please read http://ec.europa.eu/odr for legal stuff on online stores.</p>'
      expected = '<p>Please read <a href="http://ec.europa.eu/odr" target="_blank">http://ec.europa.eu/odr</a> for legal stuff on online stores.</p>'
      assert_equal(expected, helper.clickable_legal_links(html))
    end

    it 'should put no link around other URLs' do
      html = '<p>Please also look at http://forbidden.website.com</p>'
      expected = '<p>Please also look at http://forbidden.website.com</p>'
      assert_equal(expected, helper.clickable_legal_links(html))
    end
  end
end
