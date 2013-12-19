require 'spec_helper'

describe RefundsController do
  let( :user ){ FactoryGirl.create :user }
  
  describe 'POST ::create' do
    describe 'for signed in users' do
      it 'should create refund request' do
      end
    end
  end

  describe 'GET ::new' do
    describe 'for signed in users' do
      it 'should render "new" view ' do
        get :new
        response.should render_template :new
      end
    end
  end
end
