require 'spec_helper'

module Tinycms
  describe Content do
    
    context "friendly_id" do
      
      # see https://github.com/norman/friendly_id/issues/332
      it "find by slug should work" do
        content = Content.create!(:key => "test-mich") 
        Content.find("test-mich").should == content
      end
    end
  end
end