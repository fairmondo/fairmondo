#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

describe 'SingleSignOn' do
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
