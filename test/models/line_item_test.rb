#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

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
