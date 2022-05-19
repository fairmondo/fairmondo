#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class LibraryElementTest < ActiveSupport::TestCase
  subject { LibraryElement.new }

  describe 'associations' do
    should belong_to :article
    should belong_to :library
  end

  describe 'model attributes' do
    it { _(subject).must_respond_to :id }
    it { _(subject).must_respond_to :created_at }
    it { _(subject).must_respond_to :updated_at }
    it { _(subject).must_respond_to :article }
    it { _(subject).must_respond_to :library }
    it { _(subject).must_respond_to :library_id }
    it { _(subject).must_respond_to :article_id }
  end

  describe 'validations' do
    describe 'for library_id' do
      should validate_presence_of(:library_id)
      should validate_uniqueness_of(:library_id).scoped_to(:article_id)
    end
  end
end
