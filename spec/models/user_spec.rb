#
# Farinopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Farinopoly.
#
# Farinopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Farinopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Farinopoly.  If not, see <http://www.gnu.org/licenses/>.
#
require 'spec_helper'

describe User do

  let(:user) { FactoryGirl.create(:user) }
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
    it {should validate_presence_of :nickname}
    it {should validate_uniqueness_of :nickname}
  end

  context "on create" do
    subject { User.new }
    it {should validate_acceptance_of :privacy}
    it {should validate_acceptance_of :legal}
    it {should validate_acceptance_of :agecheck}
    it {should validate_presence_of :recaptcha}
  end

  context "on update" do
    it { should validate_presence_of :forename }
    it { should validate_presence_of :surname }

    describe "zip code validation" do
      before :each do
        user.country = "Deutschland"
      end
      it {should allow_value('12345').for :zip}
      it {should_not allow_value('a1b2c').for :zip}
      it {should_not allow_value('123456').for :zip}
      it {should_not allow_value('1234').for :zip}
    end

    describe "address validation" do
      it {should allow_value('Test Str. 1a').for :street}
      it {should_not allow_value('Test Str.').for :street}
    end
  end

  context "if user wants to sell" do
    before :each do
      user.wants_to_sell = true
    end

    it {should validate_presence_of :zip}
    it { should validate_presence_of :country }
    it { should validate_presence_of :street }
    it { should validate_presence_of :city }
  end

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

    describe "paypal_account_exists?" do
      it "should be true if user has paypal account" do
        FactoryGirl.create(:user, :paypal_data).paypal_account_exists?.should be_true
      end
      it "should be false if user does not have paypal account" do
        user.paypal_account_exists?.should be_false
      end
    end

    describe "bank_account_exists?" do
      it "should be true if user has bank account" do
        user.bank_account_exists?.should be_true
      end
      it "should be false if user does not have bank account" do
        FactoryGirl.create(:user, :no_bank_data).bank_account_exists?.should be_false
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
