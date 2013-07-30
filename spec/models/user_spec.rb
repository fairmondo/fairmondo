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

describe User do

  let(:user) { FactoryGirl.create(:user)}
  subject { user }

  it "has a valid Factory" do
    should be_valid
  end

  describe "associations" do
    it { should have_many(:articles).dependent(:destroy) }
    #it { should have_many(:bids).dependent(:destroy) }
    #it { should have_many(:invitations).dependent(:destroy) }
    it { should have_many(:article_templates).dependent(:destroy) }
    it { should have_many(:libraries).dependent(:destroy) }
    #it { should belong_to :invitor}
    it { should have_one(:image) }
  end

  describe "validations" do

    context "always" do
      it { should validate_presence_of :email }
    end

    context "on create" do
      subject { User.new }
      it { should validate_acceptance_of :privacy }
      it { should validate_acceptance_of :legal }
      it { should validate_acceptance_of :agecheck }
      it { should validate_presence_of :recaptcha }
    end

    context "on update" do
      it { should validate_presence_of :forename }
      it { should validate_presence_of :surname }
      it { should validate_presence_of :title }
      it { should validate_presence_of :country }
      it { should validate_presence_of :street }
      it { should validate_presence_of :city }
      it { should validate_presence_of :nickname }

      describe "zip code validation" do
        # let(:user) { FactoryGirl.create(:german_user) } # factory users are currently German by default

        it { should validate_presence_of :zip }

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
        user.customer_nr.should eq "0000000#{user.id}"
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

  describe "subclasses" do
    describe PrivateUser do
      let(:user) { FactoryGirl::create(:private_user) }
      subject { user }

      it "should have a valid factory" do
        should be_valid
      end

      it "should return the same model_name as User" do
        PrivateUser.model_name.should eq User.model_name
      end
    end

    describe LegalEntity do
      let(:user) { FactoryGirl::create(:legal_entity) }
      subject { user }

      it "should have a valid factory" do
        should be_valid
      end

      it "should return the same model_name as User" do
        LegalEntity.model_name.should eq User.model_name
      end
    end
  end

  describe "states" do
    describe "seller_states" do
      describe PrivateUser do
        let(:private_seller) { FactoryGirl::create(:private_user) }
        subject { private_seller }

        context "being a bad seller" do
          it "should be able to rate to standard seller" do
            private_seller.seller_state = "bad_seller"
            private_seller.rate_up_to_standard_seller
            private_seller.should be_standard_seller
          end
          it "should not be able to rate to good seller" do
            private_seller.seller_state = "bad_seller"
            private_seller.rate_up_to_good_seller
            private_seller.should be_bad_seller
          end
        end

        context "being a standard seller" do
          it "should be able to rate to bad seller" do
            private_seller.seller_state = "standard_seller"
            private_seller.rate_down_to_bad_seller
            private_seller.should be_bad_seller
          end
          it "should be able to rate to good seller" do
            private_seller.seller_state = "standard_seller"
            private_seller.rate_up_to_good_seller
            private_seller.should be_good_seller
          end
        end

        context "being a good seller" do
          it "should be able to rate to bad seller" do
            private_seller.seller_state = "good_seller"
            private_seller.rate_down_to_bad_seller
            private_seller.should be_bad_seller
          end
          it "should not be able to rate to standard seller" do
            private_seller.seller_state = "good_seller"
            private_seller.rate_up_to_standard_seller
            private_seller.should be_good_seller
          end
        end

      end

      describe LegalEntity do
        let(:commercial_seller) { FactoryGirl::create(:legal_entity) }
        subject { commercial_seller }
        context "being a bad seller" do
          it "should be able to rate to standard seller" do
            commercial_seller.seller_state = "bad_seller"
            commercial_seller.rate_up_to_standard_seller
            commercial_seller.should be_standard_seller
          end
          it "should not be able to rate to good1 seller" do
            commercial_seller.seller_state = "bad_seller"
            commercial_seller.rate_up_to_good1_seller
            commercial_seller.should be_bad_seller
          end
          it "should not be able to rate to good2 seller" do
            commercial_seller.seller_state = "bad_seller"
            commercial_seller.rate_up_to_good2_seller
            commercial_seller.should be_bad_seller
          end
          it "should not be able to rate to good3 seller" do
            commercial_seller.seller_state = "bad_seller"
            commercial_seller.rate_up_to_good3_seller
            commercial_seller.should be_bad_seller
          end
          it "should not be able to rate to good4 seller" do
            commercial_seller.seller_state = "bad_seller"
            commercial_seller.rate_up_to_good4_seller
            commercial_seller.should be_bad_seller
          end
        end

         context "being a standard seller" do
          it "should be able to rate to bad seller" do
            commercial_seller.seller_state = "standard_seller"
            commercial_seller.rate_down_to_bad_seller
            commercial_seller.should be_bad_seller
          end
          it "should be able to rate to good1 seller" do
            commercial_seller.seller_state = "standard_seller"
            commercial_seller.rate_up_to_good1_seller
            commercial_seller.should be_good1_seller
          end
          it "should not be able to rate to good2 seller" do
            commercial_seller.seller_state = "standard_seller"
            commercial_seller.rate_up_to_good2_seller
            commercial_seller.should be_standard_seller
          end
          it "should not be able to rate to good3 seller" do
            commercial_seller.seller_state = "standard_seller"
            commercial_seller.rate_up_to_good3_seller
            commercial_seller.should be_standard_seller
          end
          it "should not be able to rate to good4 seller" do
            commercial_seller.seller_state = "standard_seller"
            commercial_seller.rate_up_to_good4_seller
            commercial_seller.should be_standard_seller
          end
        end

        context "being a good1 seller" do
          it "should be able to rate to bad seller" do
            commercial_seller.seller_state = "good1_seller"
            commercial_seller.rate_down_to_bad_seller
            commercial_seller.should be_bad_seller
          end
          it "should not be able to rate to standard seller" do
            commercial_seller.seller_state = "good1_seller"
            commercial_seller.rate_up_to_standard_seller
            commercial_seller.should be_good1_seller
          end
          it "should be able to rate to good2 seller" do
            commercial_seller.seller_state = "good1_seller"
            commercial_seller.rate_up_to_good2_seller
            commercial_seller.should be_good2_seller
          end
          it "should not be able to rate to good3 seller" do
            commercial_seller.seller_state = "good1_seller"
            commercial_seller.rate_up_to_good3_seller
            commercial_seller.should be_good1_seller
          end
          it "should not be able to rate to good4 seller" do
            commercial_seller.seller_state = "good1_seller"
            commercial_seller.rate_up_to_good4_seller
            commercial_seller.should be_good1_seller
          end
        end

        context "being a good2 seller" do
          it "should be able to rate to bad seller" do
            commercial_seller.seller_state = "good2_seller"
            commercial_seller.rate_down_to_bad_seller
            commercial_seller.should be_bad_seller
          end
          it "should not be able to rate to standard seller" do
            commercial_seller.seller_state = "good2_seller"
            commercial_seller.rate_up_to_standard_seller
            commercial_seller.should be_good2_seller
          end
          it "should not be able to rate to good1 seller" do
            commercial_seller.seller_state = "good2_seller"
            commercial_seller.rate_up_to_good1_seller
            commercial_seller.should be_good2_seller
          end
          it "should be able to rate to good3 seller" do
            commercial_seller.seller_state = "good2_seller"
            commercial_seller.rate_up_to_good3_seller
            commercial_seller.should be_good3_seller
          end
          it "should not be able to rate to good4 seller" do
            commercial_seller.seller_state = "good2_seller"
            commercial_seller.rate_up_to_good4_seller
            commercial_seller.should be_good2_seller
          end
        end

        context "being a good3 seller" do
          it "should be able to rate to bad seller" do
            commercial_seller.seller_state = "good3_seller"
            commercial_seller.rate_down_to_bad_seller
            commercial_seller.should be_bad_seller
          end
          it "should not be able to rate to standard seller" do
            commercial_seller.seller_state = "good3_seller"
            commercial_seller.rate_up_to_standard_seller
            commercial_seller.should be_good3_seller
          end
          it "should not be able to rate to good1 seller" do
            commercial_seller.seller_state = "good3_seller"
            commercial_seller.rate_up_to_good1_seller
            commercial_seller.should be_good3_seller
          end
          it "should not be able to rate to good2 seller" do
            commercial_seller.seller_state = "good3_seller"
            commercial_seller.rate_up_to_good2_seller
            commercial_seller.should be_good3_seller
          end
          it "should be able to rate to good4 seller" do
            commercial_seller.seller_state = "good3_seller"
            commercial_seller.rate_up_to_good4_seller
            commercial_seller.should be_good4_seller
          end
        end

        context "being a good4 seller" do
          it "should be able to rate to bad seller" do
            commercial_seller.seller_state = "good4_seller"
            commercial_seller.rate_down_to_bad_seller
            commercial_seller.should be_bad_seller
          end
          it "should not be able to rate to standard seller" do
            commercial_seller.seller_state = "good4_seller"
            commercial_seller.rate_up_to_standard_seller
            commercial_seller.should be_good4_seller
          end
          it "should not be able to rate to good1 seller" do
            commercial_seller.seller_state = "good4_seller"
            commercial_seller.rate_up_to_good1_seller
            commercial_seller.should be_good4_seller
          end
          it "should not be able to rate to good2 seller" do
            commercial_seller.seller_state = "good4_seller"
            commercial_seller.rate_up_to_good2_seller
            commercial_seller.should be_good4_seller
          end
          it "should not be able to rate to good3 seller" do
            commercial_seller.seller_state = "good4_seller"
            commercial_seller.rate_up_to_good3_seller
            commercial_seller.should be_good4_seller
          end
        end
      end
    end

    describe "buyer_states" do
      context "user being a bad buyer" do
        it "should be able to rate to standard buyer" do
          user.buyer_state = "bad_buyer"
          user.rate_up_to_standard_buyer
          user.should be_standard_buyer
        end
        it "should not be able to rate to good buyer" do
          user.buyer_state = "bad_buyer"
          user.rate_up_to_good_buyer
          user.should be_bad_buyer
        end
      end

      context "user being a standard buyer" do
        it "should be able to rate to bad buyer" do
          user.buyer_state = "standard_buyer"
          user.rate_down_to_bad_buyer
          user.should be_bad_buyer
        end
        it "should be able to rate to good buyer" do
          user.buyer_state = "standard_buyer"
          user.rate_up_to_good_buyer
          user.should be_good_buyer
        end
      end

      context "user being a good buyer" do
          it "should be able to rate to bad buyer" do
            user.buyer_state = "good_buyer"
            user.rate_down_to_bad_buyer
            user.should be_bad_buyer
          end
          it "should not be able to rate to standard buyer" do
            user.buyer_state = "good_buyer"
            user.rate_up_to_standard_buyer
            user.should be_good_buyer
          end
        end
    end

  end
end
