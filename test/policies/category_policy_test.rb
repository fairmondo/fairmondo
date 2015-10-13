#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

describe CategoryPolicy do
  include PunditMatcher

  it { subject.must_permit(:select_category) }
  it { subject.must_permit(:show) }
end
