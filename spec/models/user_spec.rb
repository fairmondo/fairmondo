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

  let(:user) { FactoryGirl.create(:user) }
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

    describe "sold_transactions" do
      it "should return an array of sold transactions" do
        # sollte gefunden werden
        sold_single = FactoryGirl.create(:single_transaction, :sold,
          article: (FactoryGirl.create :article, :without_build_transaction,
            seller: user
          )
        )
        sold_partial = FactoryGirl.create(:partial_transaction, :sold,
          seller: user,
          parent: (
            FactoryGirl.create(:multiple_transaction,
              seller: user,
              article: (
                FactoryGirl.create(:article, :without_build_transaction,
                  quantity: 50,
                  seller: user
                )
              )
            )
          )
        )
        # sollte NICHT gefunden werden
        open_single = FactoryGirl.create(:single_transaction,
          seller: user,
          article: (
            FactoryGirl.create(:article, :without_build_transaction,
              seller: user
            )
          )
        )
        open_multiple = FactoryGirl.create(:multiple_transaction,
          seller: user,
          article: (
            FactoryGirl.create(:article, :without_build_transaction,
              quantity: 50,
              seller: user
            )
          )
        )
        sold_multiple = FactoryGirl.create(:multiple_transaction, :sold,
          seller: user
        )

        arr = user.sold_transactions
        arr.length.should eq 2
        arr.should include(sold_single)
        arr.should include(sold_partial)
        arr.should_not include(open_single)
        arr.should_not include(open_multiple)
      end
    end
  end

  describe "validations" do

    context "always" do
      it {should validate_presence_of :email}
      it {should validate_presence_of :nickname}
      it {should validate_uniqueness_of :nickname}
    end

    context "on create" do
      subject { User.new }
      it { should validate_acceptance_of :privacy }
      it { should validate_acceptance_of :legal }
      it { should validate_acceptance_of :agecheck }
      it { should validate_presence_of :recaptcha }
    end

    context "on update" do

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
      it { should validate_presence_of :forename }
      it { should validate_presence_of :surname }
      it {should validate_presence_of :zip}
      it { should validate_presence_of :country }
      it { should validate_presence_of :street }
      it { should validate_presence_of :city }
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

    describe "#address" do
      it "should return a string with street, address suffix, zip and city" do
        u = User.new street: 'Sesame Street 1', address_suffix: 'c/o Cookie Monster', zip: '12345', city: 'Utopia'
        u.address.should eq 'c/o Cookie Monster, Sesame Street 1, 12345 Utopia'
      end
    end
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

      describe "validations" do
        context "if LegalEntity wants to sell" do

          before :each do
            user.wants_to_sell = true
          end

          it { should validate_presence_of :terms }
          it { should validate_presence_of :cancellation }
          it {should validate_presence_of :about }

        end
      end

    end
  end

  describe "states" do
    describe "seller_states" do
      describe PrivateUser do
        let(:private_seller) { FactoryGirl::create(:private_user) }
        subject { private_seller }
        context "bad seller" do
          before :each do
            private_seller.seller_state = "bad_seller"
          end

          it "should become standard seller" do
            private_seller.rate_up
            private_seller.should be_standard_seller
          end

          context "if not trusted and not verified" do
            it "should have a salesvolume of bad_salesvolume" do
              private_seller.verified = false
              private_seller.trustcommunity = false
              private_seller.max_value_of_goods_cents.should eq $private_seller_constants['bad_salesvolume']
            end
          end
          context "if trusted" do
            it "should have a salesvolume of 17" do
              private_seller.verified = false
              private_seller.trustcommunity = true
              private_seller.max_value_of_goods_cents.should eq $private_seller_constants['bad_salesvolume']
            end
          end
          context "if verified" do
            it "should have a salesvolume of 17" do
              private_seller.verified = true
              private_seller.trustcommunity = false
              private_seller.max_value_of_goods_cents.should eq $private_seller_constants['bad_salesvolume']
            end
          end
          context "if trusted and verified" do
            it "should have a salesvolume of 17" do
              private_seller.verified = true
              private_seller.trustcommunity = true
              private_seller.max_value_of_goods_cents.should eq $private_seller_constants['bad_salesvolume']
            end
          end
        end

        context "standard seller" do
          before :each do
            private_seller.seller_state = "standard_seller"
          end

          it "should become good seller" do
            private_seller.rate_up
            private_seller.should be_good_seller
          end

          context "if not trusted and not verified" do
            it "should have a salesvolume of standard_salesvolume" do
              private_seller.verified = false
              private_seller.trustcommunity = false
              private_seller.max_value_of_goods_cents.should eq $private_seller_constants['standard_salesvolume']
            end
          end
          context "if trusted" do
            it "should have a salesvolume of standard_salesvolume + trusted_bonus" do
              private_seller.verified = false
              private_seller.trustcommunity = true
              private_seller.max_value_of_goods_cents.should eq ( $private_seller_constants['standard_salesvolume'] + $private_seller_constants['trusted_bonus'] )
            end
          end
          context "if verified" do
            it "should have a salesvolume of standard_salesvolume + verified_bonus" do
              private_seller.verified = true
              private_seller.trustcommunity = false
              private_seller.max_value_of_goods_cents.should eq ( $private_seller_constants['standard_salesvolume'] + $private_seller_constants['verified_bonus'] )
            end
          end
          context "if trusted and verified" do
            it "should have a salesvolume of standard_salesvolume + trusted_bonus + verified_bonus" do
              private_seller.verified = true
              private_seller.trustcommunity = true
              private_seller.max_value_of_goods_cents.should eq ( $private_seller_constants['standard_salesvolume'] + $private_seller_constants['trusted_bonus'] + $private_seller_constants['verified_bonus'] )
            end
          end
        end

        context "good seller" do
          before :each do
            private_seller.seller_state = "good_seller"
          end

          context "if not trusted and not verified" do
            it "should have a salesvolume of standard_salesvolume * good_factor" do
              private_seller.verified = false
              private_seller.trustcommunity = false
              private_seller.max_value_of_goods_cents.should eq ( $private_seller_constants['standard_salesvolume'] * $private_seller_constants['good_factor'] )
            end
          end
          context "if trusted" do
            it "should have a salesvolume of (standard_salesvolume + trusted_bonus ) * good_factor" do
              private_seller.verified = false
              private_seller.trustcommunity = true
              private_seller.max_value_of_goods_cents.should eq (( $private_seller_constants['standard_salesvolume'] + $private_seller_constants['trusted_bonus'] ) * $private_seller_constants['good_factor'] )
            end
          end
          context "if verified" do
            it "should have a salesvolume of (standard_salesvolume + verified_bonus ) * good_factor" do
              private_seller.verified = true
              private_seller.trustcommunity = false
              private_seller.max_value_of_goods_cents.should eq (( $private_seller_constants['standard_salesvolume'] + $private_seller_constants['verified_bonus'] ) * $private_seller_constants['good_factor'] )
            end
          end
          context "if trusted and verified" do
            it "should have a salesvolume of (standard_salesvolume + trusted_bonus + verified_bonus ) * good_factor" do
              private_seller.verified = true
              private_seller.trustcommunity = true
              private_seller.max_value_of_goods_cents.should eq (( $private_seller_constants['standard_salesvolume'] + $private_seller_constants['trusted_bonus'] + $private_seller_constants['verified_bonus'] )* $private_seller_constants['good_factor'] )
            end
          end
        end

        it "should have valid private_seller_constants" do
          private_seller.private_seller_constants[:standard_salesvolume].should eq $private_seller_constants['standard_salesvolume']
          private_seller.private_seller_constants[:verified_bonus].should eq $private_seller_constants['verified_bonus']
          private_seller.private_seller_constants[:trusted_bonus].should eq $private_seller_constants['trusted_bonus']
          private_seller.private_seller_constants[:good_factor].should eq $private_seller_constants['good_factor']
          private_seller.private_seller_constants[:bad_salesvolume].should eq $private_seller_constants['bad_salesvolume']
        end
      end

      describe LegalEntity do
        let(:commercial_seller) { FactoryGirl::create(:legal_entity) }
        subject { commercial_seller }
        context "bad seller" do
          before :each do
            commercial_seller.seller_state = "bad_seller"
          end

          it "should become standard seller" do
            commercial_seller.rate_up
            commercial_seller.should be_standard_seller
          end

          context "if not verified" do
            it "should have a salesvolume of bad_salesvolume" do
              commercial_seller.verified = false
              commercial_seller.max_value_of_goods_cents.should eq $commercial_seller_constants['bad_salesvolume']
            end
          end
          context "if verified" do
            it "should have a salesvolume of bad_salesvolume" do
              commercial_seller.verified = true
              commercial_seller.max_value_of_goods_cents.should eq $commercial_seller_constants['bad_salesvolume']
            end
          end
        end

         context "standard seller" do
          before :each do
            commercial_seller.seller_state = "standard_seller"
          end

          it "should become good1 seller" do
            commercial_seller.rate_up
            commercial_seller.should be_good1_seller
          end

          context "if not verified" do
            it "should have a salesvolume of standard_salesvolume" do
              commercial_seller.verified = false
              commercial_seller.max_value_of_goods_cents.should eq $commercial_seller_constants['standard_salesvolume']
            end
          end
          context "if verified" do
            it "should have a salesvolume of standard_salesvolume + verified_bonus" do
              commercial_seller.verified = true
              commercial_seller.max_value_of_goods_cents.should eq ( $commercial_seller_constants['standard_salesvolume'] + $commercial_seller_constants['verified_bonus'] )
            end
          end
        end

        context "good1 seller" do
          before :each do
            commercial_seller.seller_state = "good1_seller"
          end

          it "should become good2 seller" do
            commercial_seller.rate_up
            commercial_seller.should be_good2_seller
          end

          context "if not verified" do
            it "should have a salesvolume of standard_salesvolume * good_factor" do
              commercial_seller.verified = false
              commercial_seller.max_value_of_goods_cents.should eq $commercial_seller_constants['standard_salesvolume'] * $commercial_seller_constants['good_factor']
            end
          end
          context "if verified" do
            it "should have a salesvolume of ( standard_salesvolume + verified_bonus ) * good_factor" do
              commercial_seller.verified = true
              commercial_seller.max_value_of_goods_cents.should eq (( $commercial_seller_constants['standard_salesvolume'] + $commercial_seller_constants['verified_bonus'] ) * $commercial_seller_constants['good_factor'] )
            end
          end
        end

        context "good2 seller" do
          before :each do
            commercial_seller.seller_state = "good2_seller"
          end

          it "should be able to rate to good3 seller" do
            commercial_seller.rate_up
            commercial_seller.should be_good3_seller
          end

          context "if not verified" do
            it "should have a salesvolume of standard_salesvolume * good_factor^2" do
              commercial_seller.verified = false
              commercial_seller.max_value_of_goods_cents.should eq $commercial_seller_constants['standard_salesvolume'] * ( $commercial_seller_constants['good_factor']**2 )
            end
          end
          context "if verified" do
            it "should have a salesvolume of ( standard_salesvolume + verified_bonus ) * good_factor^2" do
              commercial_seller.verified = true
              commercial_seller.max_value_of_goods_cents.should eq (( $commercial_seller_constants['standard_salesvolume'] + $commercial_seller_constants['verified_bonus'] ) * ( $commercial_seller_constants['good_factor']**2 ) )
            end
          end
        end

        context "good3 seller" do
          before :each do
            commercial_seller.seller_state = "good3_seller"
          end

          it "should become good4 seller" do
            commercial_seller.rate_up
            commercial_seller.should be_good4_seller
          end

          context "if not verified" do
            it "should have a salesvolume of standard_salesvolume * good_factor^3" do
              commercial_seller.verified = false
              commercial_seller.max_value_of_goods_cents.should eq $commercial_seller_constants['standard_salesvolume'] * ( $commercial_seller_constants['good_factor']**3 )
            end
          end
          context "if verified" do
            it "should have a salesvolume of ( standard_salesvolume + verified_bonus ) * good_factor^3" do
              commercial_seller.verified = true
              commercial_seller.max_value_of_goods_cents.should eq (( $commercial_seller_constants['standard_salesvolume'] + $commercial_seller_constants['verified_bonus'] ) * ( $commercial_seller_constants['good_factor']**3 ) )
            end
          end
        end

        context "good4 seller" do
          before :each do
            commercial_seller.seller_state = "good4_seller"
          end


          context "if not verified" do
            it "should have a salesvolume of standard_salesvolume * good_factor^4" do
              commercial_seller.verified = false
              commercial_seller.max_value_of_goods_cents.should eq $commercial_seller_constants['standard_salesvolume'] * ( $commercial_seller_constants['good_factor']**4 )
            end
          end

          context "if verified" do
            it "should have a salesvolume of ( standard_salesvolume + verified_bonus ) * good_factor^4" do
              commercial_seller.verified = true
              commercial_seller.max_value_of_goods_cents.should eq (( $commercial_seller_constants['standard_salesvolume'] + $commercial_seller_constants['verified_bonus'] ) * ( $commercial_seller_constants['good_factor']**4 ) )
            end
          end
        end

        it "should have valid commercial_seller_constants" do
          commercial_seller.commercial_seller_constants[:standard_salesvolume].should eq $commercial_seller_constants['standard_salesvolume']
          commercial_seller.commercial_seller_constants[:verified_bonus].should eq $commercial_seller_constants['verified_bonus']
          commercial_seller.commercial_seller_constants[:good_factor].should eq $commercial_seller_constants['good_factor']
          commercial_seller.commercial_seller_constants[:bad_salesvolume].should eq $commercial_seller_constants['bad_salesvolume']
        end
      end
    end

    describe "buyer_states" do
      context "bad buyer" do
        before :each do
          user.buyer_state = "bad_buyer"
        end

        it "should become standard buyer" do
          user.rate_up_buyer
          user.should be_standard_buyer
        end

        context "if not trusted" do
          it "should have a purchasevolume of 6" do
            user.trustcommunity = false
            user.purchase_volume.should eq 6
          end
        end
        context "if trusted" do
          it "should have a purchasevolume of 6" do
            user.trustcommunity = true
            user.purchase_volume.should eq 6
          end
        end
      end

      context "standard buyer" do
        before :each do
          user.buyer_state = "standard_buyer"
        end

        it "should become bad buyer" do
          user.rate_down_to_bad_buyer
          user.should be_bad_buyer
        end
        it "should become good buyer" do
          user.rate_up_buyer
          user.should be_good_buyer
        end

        context "if not trusted" do
          it "should have a purchasevolume of 12" do
            user.trustcommunity = false
            user.purchase_volume.should eq 12
          end
        end
        context "if trusted" do
          it "should have a purchasevolume of 24" do
            user.trustcommunity = true
            user.purchase_volume.should eq 24
          end
        end
      end

      context "good buyer" do
        before :each do
          user.buyer_state = "good_buyer"
        end

        it "should become bad buyer" do
          user.rate_down_to_bad_buyer
          user.should be_bad_buyer
        end

        context "if not trusted" do
          it "should have a purchasevolume of 24" do
            user.trustcommunity = false
            user.purchase_volume.should eq 24
          end
        end
        context "if trusted" do
          it "should have a purchasevolume of 48" do
            user.trustcommunity = true
            user.purchase_volume.should eq 48
          end
        end
      end

      it "should have valid buyer_constants" do
        user.buyer_constants[:not_registered_purchasevolume].should eq 4
        user.buyer_constants[:standard_purchasevolume].should eq 12
        user.buyer_constants[:trusted_bonus].should eq 12
        user.buyer_constants[:good_factor].should eq 2
        user.buyer_constants[:bad_factor].should eq 6
        user.buyer_constants[:bad_purchasevolume].should eq 6
      end
    end
  end

  describe "seller rating" do
    describe PrivateUser do
      let(:private_seller) { FactoryGirl::create(:private_user) }
      before :each do
        private_seller.ratings.stub(:count){ 100 }
      end

      context "percentage of ratings" do
        before :each do
          7.times do
            FactoryGirl.create( :positive_rating, :rated_user => private_seller )
          end
          2.times do
            FactoryGirl.create( :neutral_rating, :rated_user => private_seller )
          end
          1.times do
            FactoryGirl.create( :negative_rating, :rated_user => private_seller )
          end
        end

        it "should be calculated correctly for positive ratings" do
          private_seller.update_rating_counter
          private_seller.calculate_percentage_of_biased_ratings('positive',10).should eq 70.0
        end
        it "should be calculated correctly for negative ratings" do
          private_seller.update_rating_counter
          private_seller.calculate_percentage_of_biased_ratings('negative',10).should eq 10.0
        end

      end

      context "with negative ratings over 25%" do
        before :each do
          private_seller.stub(:calculate_percentage_of_biased_ratings).with('positive', 50).and_return(50)
          private_seller.stub(:calculate_percentage_of_biased_ratings).with('neutral', 50).and_return(20)
          private_seller.stub(:calculate_percentage_of_biased_ratings).with('negative', 50).and_return(30)
        end

        it "should change percentage of negative ratings" do
          private_seller.update_rating_counter
          private_seller.percentage_of_negative_ratings.should eq 30.0
        end
        it "should change from good to bad seller" do
          private_seller.seller_state = "good_seller"
          private_seller.update_rating_counter
          private_seller.seller_state.should eq "bad_seller"
        end
        it "should change from standard to bad seller" do
          private_seller.seller_state = "standard_seller"
          private_seller.update_rating_counter
          private_seller.seller_state.should eq "bad_seller"
        end
         it "should stay bad seller" do
          private_seller.seller_state = "bad_seller"
          private_seller.update_rating_counter
          private_seller.seller_state.should eq "bad_seller"
        end
      end

       context "with negative ratings over 50%" do
        before :each do
          private_seller.stub(:calculate_percentage_of_biased_ratings).with('positive', 50).and_return(10)
          private_seller.stub(:calculate_percentage_of_biased_ratings).with('neutral', 50).and_return(25)
          private_seller.stub(:calculate_percentage_of_biased_ratings).with('negative', 50).and_return(55)
        end

        it "should mark the user as banned" do
          private_seller.update_rating_counter
          private_seller.banned.should eq true
        end
      end

      context "with positive ratings over 75%" do
        before :each do
          private_seller.stub(:calculate_percentage_of_biased_ratings).with('positive', 50).and_return(80)
          private_seller.stub(:calculate_percentage_of_biased_ratings).with('neutral', 50).and_return(10)
          private_seller.stub(:calculate_percentage_of_biased_ratings).with('negative', 50).and_return(10)
        end

        it "should change percentage of positive ratings" do
          private_seller.update_rating_counter
          private_seller.percentage_of_positive_ratings.should eq 80.0
        end
        it "should stay good seller" do
          private_seller.seller_state = "good_seller"
          private_seller.update_rating_counter
          private_seller.seller_state.should eq "good_seller"
        end
        it "should stay standard seller" do
          private_seller.seller_state = "standard_seller"
          private_seller.update_rating_counter
          private_seller.seller_state.should eq "standard_seller"
        end
         it "should change from bad to standard seller" do
          private_seller.seller_state = "bad_seller"
          private_seller.update_rating_counter
          private_seller.seller_state.should eq "standard_seller"
        end
      end

      context "with positive ratings over 90%" do
        before :each do
          private_seller.stub(:calculate_percentage_of_biased_ratings).with('positive', 50).and_return(92)
          private_seller.stub(:calculate_percentage_of_biased_ratings).with('neutral', 50).and_return(0)
          private_seller.stub(:calculate_percentage_of_biased_ratings).with('negative', 50).and_return(8)
        end

        it "should stay good seller" do
          private_seller.seller_state = "good_seller"
          private_seller.update_rating_counter
          private_seller.seller_state.should eq "good_seller"
        end
        it "should change from standard to good seller" do
          private_seller.seller_state = "standard_seller"
          private_seller.update_rating_counter
          private_seller.seller_state.should eq "good_seller"
        end
        it "should change from bad_seller to standard_seller" do
          private_seller.seller_state = "bad_seller"
          private_seller.update_rating_counter
          private_seller.seller_state.should eq "standard_seller"
        end
      end
    end

    describe LegalEntity do
      let(:commercial_seller) { FactoryGirl::create(:legal_entity) }
      before :each do
        commercial_seller.ratings.stub(:count){ 1000 }
      end

      context "with negative ratings over 25%" do
        before :each do
          commercial_seller.stub(:calculate_percentage_of_biased_ratings).with('positive', 50).and_return(50)
          commercial_seller.stub(:calculate_percentage_of_biased_ratings).with('neutral', 50).and_return(20)
          commercial_seller.stub(:calculate_percentage_of_biased_ratings).with('negative', 50).and_return(30)
        end

        it "should change from good1 to bad seller" do
          commercial_seller.seller_state = "good1_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.should eq "bad_seller"
        end
        it "should change from good2 to bad seller" do
          commercial_seller.seller_state = "good2_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.should eq "bad_seller"
        end
        it "should change from good3 to bad seller" do
          commercial_seller.seller_state = "good3_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.should eq "bad_seller"
        end
        it "should change from good4 to bad seller" do
          commercial_seller.seller_state = "good4_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.should eq "bad_seller"
        end
        it "should change from standard to bad seller" do
          commercial_seller.seller_state = "standard_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.should eq "bad_seller"
        end
        it "should stay bad seller" do
          commercial_seller.seller_state = "bad_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.should eq "bad_seller"
        end
      end

      context "with negative ratings over 50%" do
        before :each do
          commercial_seller.stub(:calculate_percentage_of_biased_ratings).with('positive', 50).and_return(10)
          commercial_seller.stub(:calculate_percentage_of_biased_ratings).with('neutral', 50).and_return(25)
          commercial_seller.stub(:calculate_percentage_of_biased_ratings).with('negative', 50).and_return(55)
        end

        it "should mark the user as banned" do
          commercial_seller.update_rating_counter
          commercial_seller.banned.should eq true
        end
      end

      context "with positive ratings over 75%" do
        before :each do
          commercial_seller.stub(:calculate_percentage_of_biased_ratings).with('positive', 50).and_return(80)
          commercial_seller.stub(:calculate_percentage_of_biased_ratings).with('neutral', 50).and_return(5)
          commercial_seller.stub(:calculate_percentage_of_biased_ratings).with('negative', 50).and_return(15)
        end

        it "should change from bad to standard seller" do
          commercial_seller.seller_state = "bad_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.should eq "standard_seller"
        end
        it "should stay standard seller" do
          commercial_seller.seller_state = "standard_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.should eq "standard_seller"
        end
        it "should stay good1 seller" do
          commercial_seller.seller_state = "good1_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.should eq "good1_seller"
        end
        it "should stay good2 seller" do
          commercial_seller.seller_state = "good2_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.should eq "good2_seller"
        end
        it "should stay good3 seller" do
          commercial_seller.seller_state = "good3_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.should eq "good3_seller"
        end
        it "should stay good4 seller" do
          commercial_seller.seller_state = "good4_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.should eq "good4_seller"
        end
      end

      context "with positive ratings over 90% in last 50 ratings" do
        before :each do
          commercial_seller.stub(:calculate_percentage_of_biased_ratings).with('positive', 50).and_return(92)
          commercial_seller.stub(:calculate_percentage_of_biased_ratings).with('neutral', 50).and_return(0)
          commercial_seller.stub(:calculate_percentage_of_biased_ratings).with('negative', 50).and_return(8)
          commercial_seller.stub(:calculate_percentage_of_biased_ratings).with('positive', 100).and_return(80)
        end

        it "should change from standard to good1 seller" do
          commercial_seller.seller_state = "standard_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.should eq "good1_seller"
        end
        it "should stay good1 seller" do
          commercial_seller.seller_state = "good1_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.should eq "good1_seller"
        end
        it "should stay good2 seller" do
          commercial_seller.seller_state = "good2_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.should eq "good2_seller"
        end
        it "should stay good3 seller" do
          commercial_seller.seller_state = "good3_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.should eq "good3_seller"
        end
        it "should stay good4 seller" do
          commercial_seller.seller_state = "good4_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.should eq "good4_seller"
        end
      end

      context "with additionally positive ratings over 90% in last 100 ratings" do
        before :each do
          commercial_seller.stub(:calculate_percentage_of_biased_ratings).with('positive', 50).and_return(95)
          commercial_seller.stub(:calculate_percentage_of_biased_ratings).with('neutral', 50).and_return(0)
          commercial_seller.stub(:calculate_percentage_of_biased_ratings).with('negative', 50).and_return(5)
          commercial_seller.stub(:calculate_percentage_of_biased_ratings).with('positive', 100).and_return(92)
          commercial_seller.stub(:calculate_percentage_of_biased_ratings).with('positive', 500).and_return(80)
          commercial_seller.stub(:calculate_percentage_of_biased_ratings).with('positive', 1000).and_return(95)
        end

        it "should change from standard_seller to good1 seller" do
          commercial_seller.seller_state = "standard_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.should eq "good1_seller"
        end
        it "should change from good1 to good2 seller" do
          commercial_seller.seller_state = "good1_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.should eq "good2_seller"
        end
        it "should stay good2 seller" do
          commercial_seller.seller_state = "good2_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.should eq "good2_seller"
        end
        it "should stay good3 seller" do
          commercial_seller.seller_state = "good3_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.should eq "good3_seller"
        end
        it "should stay good4 seller" do
          commercial_seller.seller_state = "good4_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.should eq "good4_seller"
        end
      end

      context "with additionally positive ratings over 90% in last 500 ratings" do
        before :each do
          commercial_seller.stub(:calculate_percentage_of_biased_ratings).with('positive', 50).and_return(95)
          commercial_seller.stub(:calculate_percentage_of_biased_ratings).with('neutral', 50).and_return(0)
          commercial_seller.stub(:calculate_percentage_of_biased_ratings).with('negative', 50).and_return(5)
          commercial_seller.stub(:calculate_percentage_of_biased_ratings).with('positive', 100).and_return(92)
          commercial_seller.stub(:calculate_percentage_of_biased_ratings).with('positive', 500).and_return(92)
          commercial_seller.stub(:calculate_percentage_of_biased_ratings).with('positive', 1000).and_return(80)
        end

        it "should change from standard_seller to good1 seller" do
          commercial_seller.seller_state = "standard_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.should eq "good1_seller"
        end
        it "should change from good1 to good2 seller" do
          commercial_seller.seller_state = "good1_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.should eq "good2_seller"
        end
        it "should change from good2 to good3 seller" do
          commercial_seller.seller_state = "good2_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.should eq "good3_seller"
        end
        it "should stay good3 seller" do
          commercial_seller.seller_state = "good3_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.should eq "good3_seller"
        end
        it "should stay good4 seller" do
          commercial_seller.seller_state = "good4_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.should eq "good4_seller"
        end
      end

      context "with additionally positive ratings over 90% in last 1000 ratings" do
        before :each do
          commercial_seller.stub(:calculate_percentage_of_biased_ratings).with('positive', 50).and_return(95)
          commercial_seller.stub(:calculate_percentage_of_biased_ratings).with('neutral', 50).and_return(0)
          commercial_seller.stub(:calculate_percentage_of_biased_ratings).with('negative', 50).and_return(5)
          commercial_seller.stub(:calculate_percentage_of_biased_ratings).with('positive', 100).and_return(92)
          commercial_seller.stub(:calculate_percentage_of_biased_ratings).with('positive', 500).and_return(92)
          commercial_seller.stub(:calculate_percentage_of_biased_ratings).with('positive', 1000).and_return(92)
        end

        it "should change from standard_seller to good1 seller" do
          commercial_seller.seller_state = "standard_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.should eq "good1_seller"
        end
        it "should change from good1 to good2 seller" do
          commercial_seller.seller_state = "good1_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.should eq "good2_seller"
        end
        it "should change from good2 to good3 seller" do
          commercial_seller.seller_state = "good2_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.should eq "good3_seller"
        end
        it "should change from good3 to good4 seller" do
          commercial_seller.seller_state = "good3_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.should eq "good4_seller"
        end
        it "should stay good4 seller" do
          commercial_seller.seller_state = "good4_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.should eq "good4_seller"
        end
      end

    end
  end
end
