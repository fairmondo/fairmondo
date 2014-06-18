require_relative '../test_helper'

# KontoAPI::valid? and bank_name are automatically stubbed to true / Bankname
describe BankDetailsController do

  setup do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "GET 'check_iban'" do
    context "as ajax" do
      context "if parameter validation was successful" do
        it "should return true" do
          get :check_iban, format: :json
          response.body.must_equal "true"
        end
      end

      context "if parameter validation failed" do
        it "should return false" do
          KontoAPI.stubs(:valid?).returns(false)
          get :check_iban, format: :json
          response.body.must_equal "false"
        end
      end
    end
    context "as html" do
      it "should fail" do
        -> { get :check_iban }.must_raise ActionController::UnknownFormat
      end
    end
  end

  describe "GET 'check_bic'" do
    context "as ajax" do
      context "if parameter validation was successful" do
        it "should return true" do
          get :check_bic, format: :json
          response.body.must_equal "true"
        end
      end

      context "if parameter validation failed" do
        it "should return false" do
          KontoAPI.stubs(:valid?).returns(false)
          get :check_bic, format: :json
          response.body.must_equal "false"
        end
      end
    end
    context "as html" do
      it "should fail" do
        -> { get :check_bic }.must_raise ActionController::UnknownFormat
      end
    end
  end


  describe "GET 'check'" do
    context "as ajax" do
      context "if parameter validation was successful" do
        it "should return true" do
          KontoAPI.stubs(:valid?).returns(true)
          get :check, format: :json
          response.body.must_equal "true"
        end
      end
      context "if parameter validation failed" do
        it "should return false" do
          KontoAPI.stubs(:valid?).returns(false)
          get :check, format: :json
          response.body.must_equal "false"
        end
      end
    end
    context "as html" do
      it "should fail" do
         -> { get :check }.must_raise ActionController::UnknownFormat
      end
    end
  end

  describe "GET 'get_bank_name'" do
    context "as ajax" do
      context "if parameter validation was successful" do
        it "should return the bankname" do
          get :get_bank_name, format: :json
          response.body.must_equal "\"Bankname\""
        end
      end

      context "if parameter validation failed" do
        it "should return an empty string" do
          KontoAPI.stubs(:bank_name).returns("")
          get :get_bank_name, format: :json
          response.body.must_equal "\"\""
        end
      end
    end

    context "as html" do
      it "should fail" do
        -> { get :get_bank_name }.must_raise ActionController::UnknownFormat
      end
    end
  end

end


# mit validen Parametern aufrufe, soll sie ein true zurückgeben
# mit nicht-validen Parametern aufrufe, soll sie ein false zurückgeben
