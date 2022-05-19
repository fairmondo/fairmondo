#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class ArticlesHelperTest < ActionView::TestCase
  describe 'default_organisation_from' do
    it 'should rescue from error and return nil' do
      assert_nil(helper.default_organisation_from([]))
    end
  end
end
