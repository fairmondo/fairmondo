#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class SingleSignOnTest < ActiveSupport::TestCase
  describe '::sso_secret' do
    it 'should raise error' do
      -> { SingleSignOn.sso_secret }.must_raise RuntimeError
    end
  end
  describe '::sso_url' do
    it 'should raise error' do
      -> { SingleSignOn.sso_url }.must_raise RuntimeError
    end
  end
end
