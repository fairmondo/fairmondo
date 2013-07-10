#
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

describe User do

  let(:user) { FactoryGirl.create(:user)}
  subject { user }

  it "has a valid Factory" do
    should be_valid
  end

  # relations

  it {should have_many(:articles).dependent(:destroy)}
  #it {should have_many(:bids).dependent(:destroy)}
  #it {should have_many(:invitations).dependent(:destroy)}

  it {should have_many(:article_templates).dependent(:destroy)}
  it {should have_many(:libraries).dependent(:destroy)}
  it {should have_one(:image)}

  #it {should belong_to :invitor}


  # validations

  context "always" do
    it {should validate_presence_of :email}
  end

  context "on create" do
    subject { User.new }
    it {should validate_acceptance_of :privacy}
    it {should validate_acceptance_of :legal}
    it {should validate_acceptance_of :agecheck}
    it {should validate_presence_of :recaptcha}
  end

  context "on update" do
    it {should validate_presence_of :forename}
    it {should validate_presence_of :surname}
    it {should validate_presence_of :title}
    it {should validate_presence_of :country}
    it {should validate_presence_of :street}
    it {should validate_presence_of :city}
    it {should validate_presence_of :nickname}

    describe "zip code validation" do
      let(:user) { FactoryGirl.create(:german_user) }

      it {should validate_presence_of :zip}

      it "should validate the length" do
        user.zip = 1234
        user.should_not be_valid
      end

      it "should validate the format" do
        user.zip = "a1b2c"
        user.should_not be_valid
      end
    end
  end

  # validates :zip, :presence => true, :on => :update, :zip => true
  # validates_attachment_content_type :image,:content_type => ['image/jpeg', 'image/png', 'image/gif']
  # validates_attachment_size :image, :in => 0..5.megabytes

  describe "methods" do
    describe "#fullname" do
      it "returns correct fullname" do
        user.fullname.should eq "#{user.forename} #{user.surname}"
      end
    end

    describe "#name" do
      it "returns correct name" do
        user.name.should eq user.nickname
      end
    end

    describe "#is?" do
      it "should return true when users have the same ID" do
        user.is?(user).should be_true
      end

      it "should return false when users don't have the same ID" do
        user.is?(FactoryGirl.create(:user)).should be_false
      end
    end

    describe "#customer_nr" do
      it "should have 8 digits" do
        user.customer_nr.length.should eq 8
      end

      it "should use the user_id" do
        FactoryGirl.create(:user).customer_nr.should eq "00000001"
      end
    end

  #    def update_image image
  #   if User.valid_attribute?('image', image)
  #     update_attribute 'image', image
  #   else
  #     false
  #   end
  # end

  # private

  # # Validate single attribute
  # # @api private
  # def self.valid_attribute? attr, value
  #   mock = self.new(attr => value)
  #   !mock.errors.messages.keys.find { |e| e =~ Regexp.new(attr) }
  # end

  end

end
