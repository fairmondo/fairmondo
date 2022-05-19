#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class LineItemTest < ActiveSupport::TestCase
  let(:line_item) { LineItem.new }
  let(:db_line_item) { create :line_item }

  it 'has a valid factory' do
    db_line_item.must_be :valid?
  end

  describe '#qualifies_for_belboon?' do
    let(:legal_entity_line_item) { create :line_item_with_legal_entity }
    let(:private_user_line_item) { create :line_item_with_private_user }

    it 'should return true if seller is a LegalEntity' do
      assert_equal true, legal_entity_line_item.qualifies_for_belboon?
    end

    it 'should return false if seller is a PrivateUser' do
      assert_equal false, private_user_line_item.qualifies_for_belboon?
    end
  end
end
