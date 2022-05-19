#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class CategoryPolicyTest < ActiveSupport::TestCase
  include PunditMatcher

  it { assert_permit(nil, nil, :select_category) }
  it { assert_permit(nil, nil, :show) }
end
