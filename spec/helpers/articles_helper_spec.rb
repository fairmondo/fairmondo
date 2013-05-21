require "spec_helper"

describe ArticlesHelper do
  describe "#category_button_text(name, children, pad = false)" do
    it "should return the correct html without a 'padding' argument" do
      result = helper.category_button_text 'foo', true
      result.should eq '<i class="icon-tags"></i> foo<span style=" float: right; "><i class="icon-chevron-right"></i></span>'
    end

    it "should return the correct html with padding" do
      result = helper.category_button_text 'foo', true, true
      result.should eq '<i class="icon-tags"></i> foo<span style=" float: right; padding-right:10px"><i class="icon-chevron-right"></i></span>'
    end
  end

  describe "#resource" do
    it "should return the existing resource" do
      user = User.new nickname: 'something'
      assign :resource, user
      helper.resource.should eq user
    end

    it "should return a new User without a given resource" do
      User.should_receive :new
      helper.resource
    end
  end

  describe "#devise_mapping" do
    it "should return the existing devise_mapping" do
      assign :devise_mapping, 'foo'
      helper.devise_mapping.should eq 'foo'
    end

    it "should return a new mapping if none exists" do
      Devise.should_receive(:mappings).and_return user: 'foo'
      helper.devise_mapping.should eq 'foo'
    end
  end

  describe "#get_category_tree(leaf_category)" do
    it "should return an array with parent categories of a given child category " do
      parent_category = FactoryGirl.create :category
      child_category = FactoryGirl.create :category, parent: parent_category

      helper.get_category_tree(child_category).should eq [parent_category, child_category]
    end
  end

  describe "#category_shift(level)" do
    it "should return the correct css" do
      helper.category_shift(1).should eq 'padding-left:10px;'
    end
  end
end