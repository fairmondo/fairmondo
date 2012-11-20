require 'spec_helper'

describe WelcomeController do
  render_views

  describe "GET 'index" do

    describe "for non-signed-in users" do

      it "should be successful" do
        get :index
        response.should be_success
      end
    end
  end
end