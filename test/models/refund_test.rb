#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class RefundTest < ActiveSupport::TestCase
  subject { Refund.new }

  describe 'associations' do
    should belong_to :business_transaction
  end

  describe 'attributes' do
    it { _(subject).must_respond_to :reason }
    it { _(subject).must_respond_to :description }
    it { _(subject).must_respond_to :business_transaction_id }
  end

  describe 'validations' do
    should validate_presence_of :reason
    should validate_presence_of :description
    should validate_presence_of :business_transaction_id
  end
end
