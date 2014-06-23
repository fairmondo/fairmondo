require "test_helper"

describe LineItem do
  let(:line_item) { LineItem.new }

  it "must be valid" do
    line_item.must_be :valid?
  end
end
