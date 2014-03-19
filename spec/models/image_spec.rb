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
require 'spec_helper'

describe Image do
  subject { image }
  let(:image) { FactoryGirl.create(:article_image) }

  it "has a valid Factory" do
    should be_valid
  end

  describe 'attributes' do
    it { should respond_to :id }
    it { should respond_to :image_file_name }
    it { should respond_to :image_content_type }
    it { should respond_to :image_file_size }
    it { should respond_to :image_updated_at }
    it { should respond_to :created_at }
    it { should respond_to :updated_at }
    it { should respond_to :imageable_id }
    it { should respond_to :type }
    it { should respond_to :is_title }
    it { should respond_to :external_url }
    it { should respond_to :image_processing }
  end

  describe "associations" do
    it { should belong_to :article }
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
        image.url_or_original_while_processing.should eq image.original_image_url_while_processing
      end

      it "should return the normal url when not processing" do
        #image.image_processing = false
        image.url_or_original_while_processing.should eq image.image.url(:thumb)
      end
    end
  end

end
