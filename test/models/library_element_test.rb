#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

class LibraryElementTest < ActiveSupport::TestCase
  subject { LibraryElement.new }

  describe 'associations' do
    it { subject.must belong_to :article }
    it { subject.must belong_to :library }
  end

  describe 'model attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
    it { subject.must_respond_to :article }
    it { subject.must_respond_to :library }
    it { subject.must_respond_to :library_id }
    it { subject.must_respond_to :article_id }
  end

  describe 'validations' do
    describe 'for library_id' do
      it { subject.must validate_presence_of(:library_id) }
      it { subject.must validate_uniqueness_of(:library_id).scoped_to(:article_id) }
    end
  end
end
