require 'spec_helper'

# KontoAPI::valid? and bank_name are automatically stubbed to true / Bankname
describe BankDetailsController do

  before :each do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "GET 'check_iban'" do
    context "as ajax" do
      context "if parameter validation was successful" do
        it "should return true" do
          get :check_iban, format: :json
          response.body.should eq "true"
        end
      end

      context "if parameter validation failed" do
        before :each do
          KontoAPI.stub(:valid?).and_return(false)
        end

        it "should return false" do
          get :check_iban, format: :json
          response.body.should eq "false"
        end
      end
    end
    context "as html" do
      it "should fail" do
        get :check_iban
        response.should_not be_success
      end
    end
  end

  describe "GET 'check_bic'" do
    context "as ajax" do
      context "if parameter validation was successful" do
        it "should return true" do
          get :check_bic, format: :json
          response.body.should eq "true"
        end
      end

      context "if parameter validation failed" do
        before :each do
          KontoAPI.stub(:valid?).and_return(false)
        end

        it "should return false" do
          get :check_bic, format: :json
          response.body.should eq "false"
        end
      end
    end
    context "as html" do
      it "should fail" do
        get :check_bic
        response.should_not be_success
      end
    end
  end


  describe "GET 'check'" do
    context "as ajax" do
      context "if parameter validation was successful" do
        before :each do
          KontoAPI.stub(:valid?).and_return(true)
        end
        it "should return true" do
          get :check, format: :json
          response.body.should eq "true"
        end
      end
      context "if parameter validation failed" do
        before :each do
          KontoAPI.stub(:valid?).and_return(false)
        end
        it "should return false" do
          get :check, format: :json
          response.body.should eq "false"
        end
      end
    end
    context "as html" do
      it "should fail" do
        get :check
        response.should_not be_success
      end
    end
  end

  describe "GET 'get_bank_name'" do
    context "as ajax" do
      context "if parameter validation was successful" do
        it "should return the bankname" do
          get :get_bank_name, format: :json
          response.body.should eq "\"Bankname\""
        end
      end

      context "if parameter validation failed" do
        before do
          KontoAPI.stub(:bank_name).and_return("")
        end
        it "should return an empty string" do
          get :get_bank_name, format: :json
          response.body.should eq "\"\""
        end
      end
    end

    context "as html" do
      it "should fail" do
        get :get_bank_name
        response.should_not be_success
      end
    end
  end

end


# mit validen Parametern aufrufe, soll sie ein true zurückgeben
# mit nicht-validen Parametern aufrufe, soll sie ein false zurückgeben
