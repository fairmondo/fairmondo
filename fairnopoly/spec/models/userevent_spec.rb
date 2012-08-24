require 'spec_helper'

describe Userevent do
  
  it "has a valid Factory" do
    FactoryGirl.create(:userevent).should be_valid
  end
  
  it {should belong_to :user}
  it {should belong_to :appended_object}
  
  it {should validate_presence_of :user}
  it {should validate_presence_of :event_type}
end