#
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
require 'test_helper'

describe Image do
  subject { Image.new }
  let(:image) { FactoryGirl.create(:article_image) }

  it "has a valid Factory" do
    subject.valid?.must_equal true
  end

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :image_file_name }
    it { subject.must_respond_to :image_content_type }
    it { subject.must_respond_to :image_file_size }
    it { subject.must_respond_to :image_updated_at }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
    it { subject.must_respond_to :imageable_id }
    it { subject.must_respond_to :type }
    it { subject.must_respond_to :is_title }
    it { subject.must_respond_to :external_url }
    it { subject.must_respond_to :image_processing }
  end

  describe "associations" do
    let (:article_image) { ArticleImage.new }
    let (:feedback_image) { FeedbackImage.new }
    let (:user_image) { UserImage.new }
    it { article_image.must belong_to :article }
    it { feedback_image.must belong_to :feedback }
    it { user_image.must belong_to :user }
  end

  describe "methods" do
    describe "::reprocess" do

      it "should call reprocess on image Object" do
        Image.stub_chain(:find,:image,:reprocess!) # for coverage / flush_errors with should_receive
        Image.reprocess 1
      end
    end

    describe "#url_or_original_while_processing" do
      it "should return the original url when processing" do
        image = FactoryGirl.create :article_image, :processing
        image.url_or_original_while_processing.must_equal image.original_image_url_while_processing
      end

      it "should return the normal url when not processing" do
        #image.image_processing = false
        image.url_or_original_while_processing.must_equal image.image.url(:thumb)
      end
    end
  end

end
