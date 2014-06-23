require "test_helper"

describe LineItemGroup do
  let(:line_item_group) { LineItemGroup.new }

  it "must be valid" do
    line_item_group.must_be :valid?
  end
end
