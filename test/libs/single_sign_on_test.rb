require_relative "../test_helper"

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
