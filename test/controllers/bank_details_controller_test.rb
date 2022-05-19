#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

# KontoAPI::valid? and bank_name are automatically stubbed to true / Bankname
class BankDetailsControllerTest < ActionController::TestCase
  setup do
    @user = create(:user)
    sign_in @user
  end

  describe "GET 'check_iban'" do
    context 'as ajax' do
      context 'if parameter validation was successful' do
        it 'should return true' do
          get :check_iban, format: :json
          response.body.must_equal 'true'
        end
      end

      context 'if parameter validation failed' do
        it 'should return false' do
          KontoAPI.stubs(:valid?).returns(false)
          get :check_iban, format: :json
          response.body.must_equal 'false'
        end
      end
    end
    context 'as html' do
      it 'should fail' do
        -> { get :check_iban }.must_raise ActionController::UnknownFormat
      end
    end
  end

  describe "GET 'check_bic'" do
    context 'as ajax' do
      context 'if parameter validation was successful' do
        it 'should return true' do
          get :check_bic, format: :json
          response.body.must_equal 'true'
        end
      end

      context 'if parameter validation failed' do
        it 'should return false' do
          KontoAPI.stubs(:valid?).returns(false)
          get :check_bic, format: :json
          response.body.must_equal 'false'
        end
      end
    end
    context 'as html' do
      it 'should fail' do
        -> { get :check_bic }.must_raise ActionController::UnknownFormat
      end
    end
  end
end
