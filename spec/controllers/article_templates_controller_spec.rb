require 'spec_helper'

describe ArticleTemplatesController do

  before :each do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  def valid_attributes
    article_attributes = FactoryGirl::attributes_for(:article, :categories_and_ancestors => [FactoryGirl.create(:category)])
    template_attributes = FactoryGirl.attributes_for(:article_template)
    template_attributes[:article_attributes] = article_attributes
    template_attributes
  end

  let :valid_update_attributes do
    attrs = valid_attributes
    attrs[:article_attributes].merge!(:id => @article_template.article.id)
    attrs
  end

  describe "GET new" do
    it "assigns a new article_template as @article_template" do
      get :new, {}
      assigns(:article_template).should be_a_new(ArticleTemplate)
    end
  end

  describe "GET edit" do

    before :each do
      @article_template = FactoryGirl.create(:article_template, :user => @user)
    end

    it "assigns the requested article_template as @article_template" do
      get :edit, {:id => @article_template.to_param}
      assigns(:article_template).should eq(@article_template)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new ArticleTemplate" do
        expect {
          post :create, {:article_template => valid_attributes}
        }.to change(ArticleTemplate, :count).by(1)
      end

      it "assigns a newly created article_template as @article_template" do
        post :create, {:article_template => valid_attributes}
        assigns(:article_template).should be_an ArticleTemplate
        assigns(:article_template).should be_persisted
      end

      it "redirects to the collection" do
        post :create, {:article_template => valid_attributes}
        response.should redirect_to(user_url(@user, :anchor => "my_article_templates"))
      end
    end

# why does the devise test helper expect a user_article_templates_url?
    # describe "with invalid params" do
      # it "assigns a newly created but unsaved article_template as @article_template" do
        # # Trigger the behavior that occurs when invalid params are submitted
        # ArticleTemplate.any_instance.stub(:save).and_return(false)
        # post :create, {:article_template => {}}
        # assigns(:article_template).should be_a_new(ArticleTemplate)
      # end
#
      # it "re-renders the 'new' template" do
        # # Trigger the behavior that occurs when invalid params are submitted
        # ArticleTemplate.any_instance.stub(:save).and_return(false)
        # post :create, {:article_template => {}}
        # response.should render_template("new")
      # end
    # end
  end

  describe "PUT update" do

    before :each do
      @article_template = FactoryGirl.create(:article_template, :user => @user)
    end

    describe "with valid params" do

      it "updates the requested article_template" do
        put :update, {:id => @article_template.to_param, "article_template" => {"article_attributes" => {"title" => "updated Title", "id" => @article_template.article.id}}}
        @article_template.reload
        @article_template.article.title.should == "updated Title"
      end

      it "assigns the requested article_template as @article_template" do
        put :update, {:id => @article_template.to_param, :article_template => valid_update_attributes}
        assigns(:article_template).should eq(@article_template)
      end

      it "redirects to the collection" do
        put :update, {:id => @article_template.to_param, :article_template => valid_update_attributes}
        response.should redirect_to(user_url(@user, :anchor => "my_article_templates"))
      end
    end

# why does the devise test helper expect a user_article_templates_url?
    # describe "with invalid params" do
      # it "assigns the article_template as @article_template" do
        # ArticleTemplate.any_instance.stub(:save).and_return(false)
        # put :update, {:id => @article_template.to_param, "article_template" => {"article_attributes" => {"title" => "updated Title"}}}
        # assigns(:article_template).should eq(@article_template)
      # end

      # it "re-renders the 'edit' template" do
        # ArticleTemplate.any_instance.stub(:save).and_return(false)
        # put :update, {:id => @article_template.to_param, :article_template => {}}
        # response.should render_template("edit")
      # end
    # end
  end

  describe "DELETE destroy" do

    before :each do
      @article_template = FactoryGirl.create(:article_template, :user => @user)
    end

    it "destroys the requested article_template" do
      expect {
        delete :destroy, {:id => @article_template.to_param}
      }.to change(ArticleTemplate, :count).by(-1)
    end

    it "redirects to the article_templates list" do
      delete :destroy, {:id => @article_template.to_param}
      response.should redirect_to(user_url(@user, :anchor => "my_article_templates"))
    end
  end

end
