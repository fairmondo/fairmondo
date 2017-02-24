#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

describe Content do
  subject { Content.new }

  describe 'attributes' do
    it { subject.must_respond_to :key }
    it { subject.must_respond_to :body }
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
  end

  describe 'fields' do
    describe 'friendly_id' do
      # see https://github.com/norman/friendly_id/issues/332
      it 'find by slug should work' do
        content = create :content
        Content.find(content.key).must_equal content
      end
    end
  end

  describe 'validations' do
    it { subject.must validate_presence_of :key }
  end
end
