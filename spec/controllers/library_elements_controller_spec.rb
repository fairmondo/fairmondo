require 'spec_helper'

describe LibraryElementsController do
  render_views

  describe "Library Elements" do

    describe "for non-signed-in users" do

      before :each do
        @user = FactoryGirl.create(:user)
        @library_element= FactoryGirl.create(:library_element)
      end

      it "should be a guest" do
        controller.should_not be_signed_in
      end

      it "should deny access to create" do
        put :create, :user_id => @user
        response.should redirect_to(new_user_session_path)
      end

      it "should deny access to update" do
        put :update, :user_id => @user, :id => @library_element.id
        response.should redirect_to(new_user_session_path)
      end

      it "should deny access to destroy" do
        put :destroy, :user_id => @user, :id => @library_element
        response.should redirect_to(new_user_session_path)
      end

    end

    describe "for signed-in users" do

      before :each do

        @library_element= FactoryGirl.create(:library_element)
        @library = FactoryGirl.create(:library)
        @user = @library_element.library.user
        @different_library_element= FactoryGirl.create(:library_element)
        @different_user = @different_library_element.library.user
        sign_in @user
      end

      it "should be logged in" do
        controller.should be_signed_in
      end

      it "sucessfully move a library element" do
        put :update,:user_id => @user, :id => @library_element , :library_element => { :library_id => @library.id }
        response.should redirect_to(user_libraries_url(@user, :anchor => "library"+@library.id.to_s))
        @library_element.reload.library_id.should == @library.id
      end

      it "destroy a library element" do
        expect {
          delete :destroy,:user_id => @user, :id => @library_element
        }.to change(LibraryElement, :count).by(-1)
      end

      it "shouldnt be possible to delete another users elements" do

        @user.id.should_not eq @different_user.id #by design
        
        expect {
          delete :destroy,:user_id => @different_user, :id => @different_library_element
        }.to raise_error(Pundit::NotAuthorizedError)
      end
      
      it "shouldnt be possible to edit another users elements" do

        @user.id.should_not eq @different_user.id #by design
        
        expect {
          put :update ,:user_id => @different_user, :id => @different_library_element
        }.to raise_error(Pundit::NotAuthorizedError)
      end
      
      it "shouldnt be possible to add elements to another users libraries" do

        @user.id.should_not eq @different_user.id #by design
        
        expect {
          post :create ,:user_id => @different_user, :library_element => {:library_id => @different_library_element.library }
        }.to raise_error(Pundit::NotAuthorizedError)
      end


    end

  end
end
