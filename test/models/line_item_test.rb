require_relative '../test_helper'

describe LineItem do
  let(:line_item) { LineItem.new }
  let(:db_line_item) { FactoryGirl.create :line_item }

  it 'has a valid factory' do
    db_line_item.must_be :valid?
  end

  describe '#qualifies_for_belboon?' do
    let(:conventional_line_item) { FactoryGirl.create :line_item, :with_conventional_article }
    let(:fair_line_item) { FactoryGirl.create :line_item, :with_fair_article }

    it 'should return true if seller is a LegalEntity and article is conventional' do
      assert_equal true, conventional_line_item.qualifies_for_belboon?
    end

    it 'should return false if article is fair' do
      assert_equal false, fair_line_item.qualifies_for_belboon?
    end
  end
end
