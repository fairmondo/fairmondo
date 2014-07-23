require_relative '../test_helper'

describe LineItem do
  let(:line_item) { LineItem.new }
  let(:db_line_item) { FactoryGirl.create :line_item }

  it "has a valid factory" do
    db_line_item.must_be :valid?
  end
end
