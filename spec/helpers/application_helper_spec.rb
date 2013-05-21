require "spec_helper"

describe ApplicationHelper do
  describe "#params_without(key)" do
    it "should return params without the given key" do
      controller.params = {a: 'b', deleteme: 'c'}
      result = helper.params_without :deleteme
      result.should have_key :a
      result.should_not have_key :deleteme
    end
  end

  describe "#params_without_reset_page" do
    it "should return params without 'page' and the given key" do
      controller.params = {a: 'b', deleteme: 'c', 'page' => 'd'}
      result = helper.params_without_reset_page :deleteme
      result.should have_key :a
      result.should_not have_key :deleteme
      result.should_not have_key 'page'
    end
  end

  describe "#params_with(key, value)" do
    it "should return params with the given data" do
      controller.params = {a: 'b'}
      result = helper.params_with :b, 'c'
      result.should have_key :a
      result[:b].should eq 'c'
    end
  end

  describe "#params_replace(old, new, value)" do
    it "should return params a replaced key" do
      controller.params = {old: 'foobar'}
      result = helper.params_replace :old, :new, 'bazfuz'
      result.should_not have_key :old
      result[:new].should eq 'bazfuz'
    end
  end
end