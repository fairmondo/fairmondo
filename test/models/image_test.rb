#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  subject { Image.new }
  let(:image) { create(:article_image) }

  it 'has a valid Factory' do
    subject.valid?.must_equal true
  end

  describe 'attributes' do
    it { _(subject).must_respond_to :id }
    it { _(subject).must_respond_to :image_file_name }
    it { _(subject).must_respond_to :image_content_type }
    it { _(subject).must_respond_to :image_file_size }
    it { _(subject).must_respond_to :image_updated_at }
    it { _(subject).must_respond_to :created_at }
    it { _(subject).must_respond_to :updated_at }
    it { _(subject).must_respond_to :imageable_id }
    it { _(subject).must_respond_to :type }
    it { _(subject).must_respond_to :is_title }
    it { _(subject).must_respond_to :external_url }
    it { _(subject).must_respond_to :image_processing }
  end

  describe 'associations' do
    describe 'article_image' do
      subject { ArticleImage.new }

      should belong_to :article
    end

    describe 'feedback image' do
      subject { FeedbackImage.new }

      should belong_to :feedback
    end

    describe 'user image' do
      subject { UserImage.new }

      should belong_to :user
    end
  end

  describe 'methods' do
    describe '::reprocess' do
      it 'should call reprocess on image Object' do
        Image.stub_chain(:find, :image, :reprocess!) # for coverage / flush_errors with should_receive
        Image.reprocess 1
      end
    end

    describe '#url_or_original_while_processing' do
      it 'should return the original url when processing' do
        image = create :article_image, :processing
        image.url_or_original_while_processing.must_equal image.original_image_url_while_processing
      end

      it 'should return the normal url when not processing' do
        # image.image_processing = false
        image.url_or_original_while_processing.must_equal image.image.url(:thumb)
      end
    end
  end
end
