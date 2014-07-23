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
require_relative '../test_helper'

describe User do
  let(:user) { FactoryGirl.create(:user) }
  subject { User.new }

  it "has a valid Factory" do
    user.valid?.must_equal true
  end

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :slug }
    it { subject.must_respond_to :email }
    it { subject.must_respond_to :encrypted_password }
    it { subject.must_respond_to :reset_password_token }
    it { subject.must_respond_to :sign_in_count }
    it { subject.must_respond_to :reset_password_sent_at }
    it { subject.must_respond_to :current_sign_in_at }
    it { subject.must_respond_to :last_sign_in_ip }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
    it { subject.must_respond_to :nickname }
    it { subject.must_respond_to :invitor_id }
    it { subject.must_respond_to :trustcommunity }
    it { subject.must_respond_to :confirmation_token }
    it { subject.must_respond_to :confirmed_at }
    it { subject.must_respond_to :confirmation_sent_at }
    it { subject.must_respond_to :unconfirmed_email }
    it { subject.must_respond_to :banned }
    it { subject.must_respond_to :about_me }
    it { subject.must_respond_to :terms }
    it { subject.must_respond_to :cancellation }
    it { subject.must_respond_to :about }
    it { subject.must_respond_to :phone }
    it { subject.must_respond_to :mobile }
    it { subject.must_respond_to :fax }
    it { subject.must_respond_to :type }
    it { subject.must_respond_to :ngo }
    it { subject.must_respond_to :bank_account_owner }
    it { subject.must_respond_to :bank_account_number }
    it { subject.must_respond_to :bank_code }
    it { subject.must_respond_to :bank_name }
    it { subject.must_respond_to :iban }
    it { subject.must_respond_to :bic }
    it { subject.must_respond_to :paypal_account }
    it { subject.must_respond_to :seller_state }
    it { subject.must_respond_to :buyer_state }
    it { subject.must_respond_to :verified }
    it { subject.must_respond_to :bankaccount_warning }
    it { subject.must_respond_to :percentage_of_positive_ratings }
    it { subject.must_respond_to :percentage_of_negative_ratings }
    it { subject.must_respond_to :percentage_of_neutral_ratings }
    it { subject.must_respond_to :direct_debit }
    it { subject.must_respond_to :value_of_goods_cents }
    it {    user.must_respond_to :max_value_of_goods_cents } # implemented on all subclasses
    it { subject.must_respond_to :max_value_of_goods_cents_bonus }
    it { subject.must_respond_to :fastbill_subscription_id }
    it { subject.must_respond_to :fastbill_id }
    it { subject.must_respond_to :vacationing }
    it { subject.must_respond_to :standard_address_id }
    it { subject.must_respond_to :admin }

  end
  describe "associations" do
    it { subject.must have_many(:addresses).dependent(:destroy) }
    it { subject.must belong_to(:standard_address) }
    it { subject.must have_many(:articles).dependent(:destroy) }
    it { subject.must have_many(:libraries).dependent(:destroy) }
    it { subject.must have_one(:image) }
    #it { subject.must have_many(:line_item_groups) }
    it { subject.must have_many(:seller_line_item_groups) }
    it { subject.must have_many(:buyer_line_item_groups) }

  end

  describe "validations" do
    describe "always" do
      it {user.must validate_presence_of :email}
      it {user.must validate_presence_of :nickname}
      it {user.must validate_uniqueness_of :nickname}
    end

    describe "on create" do
      it { subject.must validate_acceptance_of :agecheck }
      it { subject.must validate_acceptance_of :legal }
    end

    describe "on update" do
      describe "zip code validation" do
        before :each do
          user.standard_address.country = "Deutschland"
        end

        it {user.standard_address.must allow_value('12345').for :zip}
        it {user.standard_address.wont allow_value('a1b2c').for :zip}
        it {user.standard_address.wont allow_value('123456').for :zip}
        it {user.standard_address.wont allow_value('1234').for :zip}
      end

      describe "address validation" do
        it {user.standard_address.must allow_value('Test Str. 1a').for :address_line_1}
        it {user.standard_address.wont allow_value('Test Str.').for :address_line_1}
      end
    end

    describe "if user wants to sell" do
      before :each do
        user.wants_to_sell = true
      end
      it { user.standard_address.must validate_presence_of :first_name }
      it { user.standard_address.must validate_presence_of :last_name }
      it { user.standard_address.must validate_presence_of :address_line_1 }
      it { user.standard_address.must validate_presence_of :zip}
      it { user.standard_address.must validate_presence_of :city }
      it { user.standard_address.must validate_presence_of :country }
    end
  end

  describe "methods" do

    describe "#count_value_of_goods" do
      it "should sum the value of active goods" do
        article = FactoryGirl.create :article, seller: user
        second_article = FactoryGirl.create :article, seller: user
        user.articles.reload
        user.count_value_of_goods
        user.value_of_goods_cents.must_equal(article.price_cents + second_article.price_cents)
      end

      it "should not sum the value of inactive goods" do
        FactoryGirl.create :preview_article, seller: user
        user.count_value_of_goods
        user.value_of_goods_cents.must_equal 0
      end
    end

    describe "#fullname" do
      it "returns correct fullname" do
        user.fullname.must_equal "#{user.standard_address_first_name} #{user.standard_address_last_name}"
      end
    end

    describe "#name" do
      it "returns correct name" do
        user.name.must_equal user.nickname
      end
    end

    describe "#is?" do
      it "should return true when users have the same ID" do
        user.is?(user).must_equal true
      end

      it "should return false when users don't have the same ID" do
        user.is?(FactoryGirl.create(:user)).must_equal false
      end
    end

    describe "#customer_nr" do
      it "should have 8 digits" do
        user.customer_nr.length.must_equal 8
      end

      it "should use the user_id" do
        user.customer_nr.must_equal "0000000#{user.id}"
      end
    end

    describe "paypal_account_exists?" do
      it "should be true if user has paypal account" do
        FactoryGirl.create(:user, :paypal_data).paypal_account_exists?.must_equal true
      end
      it "should be false if user does not have paypal account" do
        user.paypal_account_exists?.must_equal false
      end
    end

    describe "bank_account_exists?" do
      it "should be true if user has bank account" do
        user.bank_account_exists?.must_equal true
      end
      it "should be false if user does not have bank account" do
        FactoryGirl.create(:user, :no_bank_data).bank_account_exists?.must_equal false
      end
    end

    describe '#update_fastbill_profile' do
      let(:user) {FactoryGirl.create :user, :fastbill}

      it 'should call FastBillAPI.update_profile if user has fastbill profile' do
        # FastbillAPI.should receive(:update_profile).with(user)
        Fastbill::Automatic::Customer.expects(:get).returns [Fastbill::Automatic::Customer.new]
        Fastbill::Automatic::Customer.any_instance.stubs(:update_attributes)
        user.update_fastbill_profile
      end
    end

    describe '#address' do
      it 'should return a string with standard_addresse\'s address_line_1, address_line_2, zip and city' do
        u = User.new
        u.standard_address = Address.new(address_line_1: 'Sesame Street 1', address_line_2: 'c/o Cookie Monster', zip: '12345', city: 'Utopia')
        u.address.must_equal 'Sesame Street 1, c/o Cookie Monster, 12345 Utopia'
      end
    end

    describe '#notify' do
      it 'should be possible to notify a user (only once)' do
        assert_difference 'Notice.count', 1 do
          user.notify 'test','test/test'
          user.notify 'test','test/test'
        end
      end
    end

    describe "#calculate_percentage_of_biased_ratings" do

      before :each do
        last_ratings = []
        7.times{ last_ratings << Rating.new(:rating =>"positive") }
        1.times{ last_ratings << Rating.new(:rating =>"negative") }
        2.times{ last_ratings << Rating.new(:rating =>"neutral") }

        user.stub_chain(:ratings,:select,:limit).returns last_ratings
      end

      it "should be calculated correctly for positive ratings" do
        user.calculate_percentage_of_biased_ratings('positive',10).must_equal 70.0
      end
      it "should be calculated correctly for negative ratings" do
        user.calculate_percentage_of_biased_ratings('negative',10).must_equal 10.0
      end

    end

  end


  describe "subclasses" do
    describe PrivateUser do
      let(:user) { FactoryGirl::create(:private_user) }

      it "should have a valid factory" do
        user.valid?.must_equal true
      end

      it "should return the same model_name as User" do
        PrivateUser.model_name.must_equal User.model_name
      end
    end

    describe LegalEntity do
      let(:db_user) { FactoryGirl::create(:legal_entity) }

      it "should have a valid factory" do
        db_user.valid?.must_equal true
      end

      it "should return the same model_name as User" do
        LegalEntity.model_name.must_equal User.model_name
      end

      describe "validations" do
        describe "if LegalEntity wants to sell" do

          before :each do
            db_user.wants_to_sell = true
          end

          it { db_user.must validate_presence_of :terms }
          it { db_user.must validate_presence_of :cancellation }
          it { db_user.must validate_presence_of :about }

        end
      end

    end
  end

  describe "seller states" do
    describe PrivateUser do
      let(:private_seller) { FactoryGirl::create(:private_user) }

      describe "bad seller" do
        before :each do
          private_seller.seller_state = "bad_seller"
        end

        it "should become standard seller" do
          private_seller.rate_up
          private_seller.standard_seller?.must_equal true
        end

        it "should have a salesvolume of bad_salesvolume if not trusted and not verified" do
          private_seller.verified = false
          private_seller.trustcommunity = false
          private_seller.max_value_of_goods_cents.must_equal $private_seller_constants['bad_salesvolume']
        end

        it "should have a salesvolume of 17 if trusted" do
          private_seller.verified = false
          private_seller.trustcommunity = true
          private_seller.max_value_of_goods_cents.must_equal $private_seller_constants['bad_salesvolume']
        end

        it "should have a salesvolume of 17 if verified" do
          private_seller.verified = true
          private_seller.trustcommunity = false
          private_seller.max_value_of_goods_cents.must_equal $private_seller_constants['bad_salesvolume']
        end

        it "should have a salesvolume of 17 if trusted and verified" do
          private_seller.verified = true
          private_seller.trustcommunity = true
          private_seller.max_value_of_goods_cents.must_equal $private_seller_constants['bad_salesvolume']
        end
      end #/bad seller

      describe "standard seller" do
        before :each do
          private_seller.seller_state = "standard_seller"
        end

        it "should become good seller" do
          private_seller.rate_up
          private_seller.good_seller?.must_equal true
        end

        it "should have a salesvolume of standard_salesvolume if not trusted and not verified" do
          private_seller.verified = false
          private_seller.trustcommunity = false
          private_seller.max_value_of_goods_cents.must_equal $private_seller_constants['standard_salesvolume']
        end

        it "should have a salesvolume of standard_salesvolume + trusted_bonus if trusted" do
          private_seller.verified = false
          private_seller.trustcommunity = true
          private_seller.max_value_of_goods_cents.must_equal($private_seller_constants['standard_salesvolume'] + $private_seller_constants['trusted_bonus'])
        end

        it "should have a salesvolume of standard_salesvolume + verified_bonus if verified" do
          private_seller.verified = true
          private_seller.trustcommunity = false
          private_seller.max_value_of_goods_cents.must_equal( $private_seller_constants['standard_salesvolume'] + $private_seller_constants['verified_bonus'] )
        end

        it "should have a salesvolume of standard_salesvolume + trusted_bonus + verified_bonus if trusted and verified" do
          private_seller.verified = true
          private_seller.trustcommunity = true
          private_seller.max_value_of_goods_cents.must_equal( $private_seller_constants['standard_salesvolume'] + $private_seller_constants['trusted_bonus'] + $private_seller_constants['verified_bonus'] )
        end
      end #/standard seller

      describe "good seller" do
        before :each do
          private_seller.seller_state = "good_seller"
        end

        it "should have a salesvolume of standard_salesvolume * good_factor if not trusted and not verified" do
          private_seller.verified = false
          private_seller.trustcommunity = false
          private_seller.max_value_of_goods_cents.must_equal( $private_seller_constants['standard_salesvolume'] * $private_seller_constants['good_factor'] )
        end

        it "should have a salesvolume of (standard_salesvolume + trusted_bonus ) * good_factor if trusted" do
          private_seller.verified = false
          private_seller.trustcommunity = true
          private_seller.max_value_of_goods_cents.must_equal(( $private_seller_constants['standard_salesvolume'] + $private_seller_constants['trusted_bonus'] ) * $private_seller_constants['good_factor'] )
        end

        it "should have a salesvolume of (standard_salesvolume + verified_bonus ) * good_factor if verified" do
          private_seller.verified = true
          private_seller.trustcommunity = false
          private_seller.max_value_of_goods_cents.must_equal(( $private_seller_constants['standard_salesvolume'] + $private_seller_constants['verified_bonus'] ) * $private_seller_constants['good_factor'] )
        end

        it "should have a salesvolume of (standard_salesvolume + trusted_bonus + verified_bonus ) * good_factor if trusted and verified" do
          private_seller.verified = true
          private_seller.trustcommunity = true
          private_seller.max_value_of_goods_cents.must_equal(( $private_seller_constants['standard_salesvolume'] + $private_seller_constants['trusted_bonus'] + $private_seller_constants['verified_bonus'] )* $private_seller_constants['good_factor'] )
        end
      end #/good seller

      it "should have valid private_seller_constants" do
        private_seller.private_seller_constants[:standard_salesvolume].must_equal $private_seller_constants['standard_salesvolume']
        private_seller.private_seller_constants[:verified_bonus].must_equal $private_seller_constants['verified_bonus']
        private_seller.private_seller_constants[:trusted_bonus].must_equal $private_seller_constants['trusted_bonus']
        private_seller.private_seller_constants[:good_factor].must_equal $private_seller_constants['good_factor']
        private_seller.private_seller_constants[:bad_salesvolume].must_equal $private_seller_constants['bad_salesvolume']
      end
    end

    describe LegalEntity do
      let(:commercial_seller) { FactoryGirl::create(:legal_entity) }
      subject { commercial_seller }

      describe "bad seller" do
        before :each do
          commercial_seller.seller_state = "bad_seller"
        end

        it "should become standard seller" do
          commercial_seller.rate_up
          commercial_seller.standard_seller?.must_equal true
        end

        it "should have a salesvolume of bad_salesvolume if not verified" do
          commercial_seller.verified = false
          commercial_seller.max_value_of_goods_cents.must_equal $commercial_seller_constants['bad_salesvolume']
        end

        it "should have a salesvolume of bad_salesvolume if verified" do
          commercial_seller.verified = true
          commercial_seller.max_value_of_goods_cents.must_equal $commercial_seller_constants['bad_salesvolume']
        end
      end #/bad seller

       describe "standard seller" do
        before :each do
          commercial_seller.seller_state = "standard_seller"
        end

        it "should become good1 seller" do
          commercial_seller.rate_up
          commercial_seller.good1_seller?.must_equal true
        end

        it "should have a salesvolume of standard_salesvolume if not verified" do
          commercial_seller.verified = false
          commercial_seller.max_value_of_goods_cents.must_equal $commercial_seller_constants['standard_salesvolume']
        end

        it "should have a salesvolume of standard_salesvolume + verified_bonus if verified" do
          commercial_seller.verified = true
          commercial_seller.max_value_of_goods_cents.must_equal( $commercial_seller_constants['standard_salesvolume'] + $commercial_seller_constants['verified_bonus'] )
        end
      end #/standard seller

      describe "good1 seller" do
        before :each do
          commercial_seller.seller_state = "good1_seller"
        end

        it "should become good2 seller" do
          commercial_seller.rate_up
          commercial_seller.good2_seller?.must_equal true
        end

        it "should have a salesvolume of standard_salesvolume * good_factor if not verified" do
          commercial_seller.verified = false
          commercial_seller.max_value_of_goods_cents.must_equal $commercial_seller_constants['standard_salesvolume'] * $commercial_seller_constants['good_factor']
        end

        it "should have a salesvolume of ( standard_salesvolume + verified_bonus ) * good_factor if verified" do
          commercial_seller.verified = true
          commercial_seller.max_value_of_goods_cents.must_equal(( $commercial_seller_constants['standard_salesvolume'] + $commercial_seller_constants['verified_bonus'] ) * $commercial_seller_constants['good_factor'] )
        end
      end #/good1 seller

      describe "good2 seller" do
        before :each do
          commercial_seller.seller_state = "good2_seller"
        end

        it "should be able to rate to good3 seller" do
          commercial_seller.rate_up
          commercial_seller.good3_seller?.must_equal true
        end

        it "should have a salesvolume of standard_salesvolume * good_factor^2 if not verified" do
          commercial_seller.verified = false
          commercial_seller.max_value_of_goods_cents.must_equal $commercial_seller_constants['standard_salesvolume'] * ( $commercial_seller_constants['good_factor']**2 )
        end

        it "should have a salesvolume of ( standard_salesvolume + verified_bonus ) * good_factor^2 if verified" do
          commercial_seller.verified = true
          commercial_seller.max_value_of_goods_cents.must_equal(( $commercial_seller_constants['standard_salesvolume'] + $commercial_seller_constants['verified_bonus'] ) * ( $commercial_seller_constants['good_factor']**2 ) )
        end
      end #/good2 seller

      describe "good3 seller" do
        before :each do
          commercial_seller.seller_state = "good3_seller"
        end

        it "should become good4 seller" do
          commercial_seller.rate_up
          commercial_seller.good4_seller?.must_equal true
        end

        it "should have a salesvolume of standard_salesvolume * good_factor^3 if not verified" do
          commercial_seller.verified = false
          commercial_seller.max_value_of_goods_cents.must_equal $commercial_seller_constants['standard_salesvolume'] * ( $commercial_seller_constants['good_factor']**3 )
        end

        it "should have a salesvolume of ( standard_salesvolume + verified_bonus ) * good_factor^3 if verified" do
          commercial_seller.verified = true
          commercial_seller.max_value_of_goods_cents.must_equal(( $commercial_seller_constants['standard_salesvolume'] + $commercial_seller_constants['verified_bonus'] ) * ( $commercial_seller_constants['good_factor']**3 ) )
        end
      end #/good3 seller

      describe "good4 seller" do
        before :each do
          commercial_seller.seller_state = "good4_seller"
        end

        it "should have a salesvolume of standard_salesvolume * good_factor^4 if not verified" do
          commercial_seller.verified = false
          commercial_seller.max_value_of_goods_cents.must_equal $commercial_seller_constants['standard_salesvolume'] * ( $commercial_seller_constants['good_factor']**4 )
        end

        it "should have a salesvolume of ( standard_salesvolume + verified_bonus ) * good_factor^4 if verified" do
          commercial_seller.verified = true
          commercial_seller.max_value_of_goods_cents.must_equal(( $commercial_seller_constants['standard_salesvolume'] + $commercial_seller_constants['verified_bonus'] ) * ( $commercial_seller_constants['good_factor']**4 ) )
        end
      end #/good4 seller

      it "should have valid commercial_seller_constants" do
        commercial_seller.commercial_seller_constants[:standard_salesvolume].must_equal $commercial_seller_constants['standard_salesvolume']
        commercial_seller.commercial_seller_constants[:verified_bonus].must_equal $commercial_seller_constants['verified_bonus']
        commercial_seller.commercial_seller_constants[:good_factor].must_equal $commercial_seller_constants['good_factor']
        commercial_seller.commercial_seller_constants[:bad_salesvolume].must_equal $commercial_seller_constants['bad_salesvolume']
      end
    end
  end # /seller states

  describe "buyer_states" do
    describe "bad buyer" do
      before :each do
        user.buyer_state = "bad_buyer"
      end

      it "should become standard buyer" do
        user.rate_up_buyer
        user.standard_buyer?.must_equal true
      end

      it "should have a purchasevolume of 6 if not trusted" do
        user.trustcommunity = false
        user.purchase_volume.must_equal 6
      end

      it "should have a purchasevolume of 6 if trusted" do
        user.trustcommunity = true
        user.purchase_volume.must_equal 6
      end
    end

    describe "standard buyer" do
      before :each do
        user.buyer_state = "standard_buyer"
      end

      it "should become bad buyer" do
        user.rate_down_to_bad_buyer
        user.bad_buyer?.must_equal true
      end

      it "should become good buyer" do
        user.rate_up_buyer
        user.good_buyer?.must_equal true
      end

      it "should have a purchasevolume of 12 if not trusted" do
        user.trustcommunity = false
        user.purchase_volume.must_equal 12
      end

      it "should have a purchasevolume of 24 if trusted" do
        user.trustcommunity = true
        user.purchase_volume.must_equal 24
        end
    end

    describe "good buyer" do
      before :each do
        user.buyer_state = "good_buyer"
      end

      it "should become bad buyer" do
        user.rate_down_to_bad_buyer
        user.bad_buyer?.must_equal true
      end

      it "should have a purchasevolume of 24 if not trusted" do
        user.trustcommunity = false
        user.purchase_volume.must_equal 24
      end

      it "should have a purchasevolume of 48 if trusted" do
        user.trustcommunity = true
        user.purchase_volume.must_equal 48
      end
    end

    it "should have valid buyer_constants" do
      user.buyer_constants[:not_registered_purchasevolume].must_equal 4
      user.buyer_constants[:standard_purchasevolume].must_equal 12
      user.buyer_constants[:bad_purchasevolume].must_equal 6
      user.buyer_constants[:trusted_bonus].must_equal 12
      user.buyer_constants[:good_factor].must_equal 2
    end
  end # /buyer states

  describe "seller rating" do
    describe PrivateUser do
      let(:private_seller) { FactoryGirl::create(:private_user) }

      describe "with negative ratings over 25%" do
        before :each do
          private_seller.ratings.stubs(:count).returns 21
          private_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 50).returns(50)
          private_seller.stubs(:calculate_percentage_of_biased_ratings).with('neutral', 50).returns(20)
          private_seller.stubs(:calculate_percentage_of_biased_ratings).with('negative', 50).returns(30)
        end

        it "should change percentage of negative ratings" do
          private_seller.update_rating_counter
          private_seller.percentage_of_negative_ratings.must_equal 30.0
        end
        it "should change from good to bad seller" do
          private_seller.seller_state = "good_seller"
          private_seller.update_rating_counter
          private_seller.seller_state.must_equal "bad_seller"
        end
        it "should change from standard to bad seller" do
          private_seller.seller_state = "standard_seller"
          private_seller.update_rating_counter
          private_seller.seller_state.must_equal "bad_seller"
        end
         it "should stay bad seller" do
          private_seller.seller_state = "bad_seller"
          private_seller.update_rating_counter
          private_seller.seller_state.must_equal "bad_seller"
        end
      end

      describe "with negative ratings over 50%" do
        before :each do
          private_seller.ratings.stubs(:count).returns 21
          private_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 50).returns(10)
          private_seller.stubs(:calculate_percentage_of_biased_ratings).with('neutral', 50).returns(25)
          private_seller.stubs(:calculate_percentage_of_biased_ratings).with('negative', 50).returns(55)
        end

        it "should mark the user as banned" do
          private_seller.update_rating_counter
          private_seller.banned.must_equal true
        end
      end

      describe "with positive ratings over 75%" do
        before :each do
          private_seller.ratings.stubs(:count).returns 21
          private_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 50).returns(80)
          private_seller.stubs(:calculate_percentage_of_biased_ratings).with('neutral', 50).returns(10)
          private_seller.stubs(:calculate_percentage_of_biased_ratings).with('negative', 50).returns(10)
        end

        it "should change percentage of positive ratings" do
          private_seller.update_rating_counter
          private_seller.percentage_of_positive_ratings.must_equal 80.0
        end
        it "should stay good seller" do
          private_seller.seller_state = "good_seller"
          private_seller.update_rating_counter
          private_seller.seller_state.must_equal "good_seller"
        end
        it "should stay standard seller" do
          private_seller.seller_state = "standard_seller"
          private_seller.update_rating_counter
          private_seller.seller_state.must_equal "standard_seller"
        end
         it "should change from bad to standard seller" do
          private_seller.seller_state = "bad_seller"
          private_seller.update_rating_counter
          private_seller.seller_state.must_equal "standard_seller"
        end
      end

      describe "with positive ratings over 90%" do
        before :each do
          private_seller.ratings.stubs(:count).returns 21
          private_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 50).returns(92)
          private_seller.stubs(:calculate_percentage_of_biased_ratings).with('neutral', 50).returns(0)
          private_seller.stubs(:calculate_percentage_of_biased_ratings).with('negative', 50).returns(8)
        end

        it "should stay good seller" do
          private_seller.seller_state = "good_seller"
          private_seller.update_rating_counter
          private_seller.seller_state.must_equal "good_seller"
        end
        it "should change from standard to good seller" do
          private_seller.seller_state = "standard_seller"
          private_seller.update_rating_counter
          private_seller.seller_state.must_equal "good_seller"
        end
        it "should change from bad_seller to standard_seller" do
          private_seller.seller_state = "bad_seller"
          private_seller.update_rating_counter
          private_seller.seller_state.must_equal "standard_seller"
        end
      end
    end

    describe LegalEntity do
      let(:commercial_seller) { FactoryGirl::create(:legal_entity) }

      describe "with negative ratings over 25%" do
        before :each do
          commercial_seller.ratings.stubs(:count).returns 1000
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 50).returns(50)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('neutral', 50).returns(20)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('negative', 50).returns(30)
        end

        it "should change from good1 to bad seller" do
          commercial_seller.seller_state = "good1_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal "bad_seller"
        end
        it "should change from good2 to bad seller" do
          commercial_seller.seller_state = "good2_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal "bad_seller"
        end
        it "should change from good3 to bad seller" do
          commercial_seller.seller_state = "good3_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal "bad_seller"
        end
        it "should change from good4 to bad seller" do
          commercial_seller.seller_state = "good4_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal "bad_seller"
        end
        it "should change from standard to bad seller" do
          commercial_seller.seller_state = "standard_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal "bad_seller"
        end
        it "should stay bad seller" do
          commercial_seller.seller_state = "bad_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal "bad_seller"
        end
      end

      describe "with negative ratings over 50%" do
        before :each do
          commercial_seller.ratings.stubs(:count).returns 1000
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 50).returns(10)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('neutral', 50).returns(25)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('negative', 50).returns(55)
        end

        it "should mark the user as banned" do
          commercial_seller.update_rating_counter
          commercial_seller.banned.must_equal true
        end
      end

      describe "with positive ratings over 75%" do
        before :each do
          commercial_seller.ratings.stubs(:count).returns 1000
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 50).returns(80)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('neutral', 50).returns(5)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('negative', 50).returns(15)
        end

        it "should change from bad to standard seller" do
          commercial_seller.seller_state = "bad_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal "standard_seller"
        end
        it "should stay standard seller" do
          commercial_seller.seller_state = "standard_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal "standard_seller"
        end
        it "should stay good1 seller" do
          commercial_seller.seller_state = "good1_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal "good1_seller"
        end
        it "should stay good2 seller" do
          commercial_seller.seller_state = "good2_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal "good2_seller"
        end
        it "should stay good3 seller" do
          commercial_seller.seller_state = "good3_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal "good3_seller"
        end
        it "should stay good4 seller" do
          commercial_seller.seller_state = "good4_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal "good4_seller"
        end
      end

      describe "with positive ratings over 90% in last 50 ratings" do
        before :each do
          commercial_seller.ratings.stubs(:count).returns 1000
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 50).returns(92)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('neutral', 50).returns(0)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('negative', 50).returns(8)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 100).returns(80)
        end

        it "should change from standard to good1 seller" do
          commercial_seller.seller_state = "standard_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal "good1_seller"
        end
        it "should stay good1 seller" do
          commercial_seller.seller_state = "good1_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal "good1_seller"
        end
        it "should stay good2 seller" do
          commercial_seller.seller_state = "good2_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal "good2_seller"
        end
        it "should stay good3 seller" do
          commercial_seller.seller_state = "good3_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal "good3_seller"
        end
        it "should stay good4 seller" do
          commercial_seller.seller_state = "good4_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal "good4_seller"
        end
      end

      describe "with additionally positive ratings over 90% in last 100 ratings" do
        before :each do
          commercial_seller.ratings.stubs(:count).returns 1000
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 50).returns(95)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('neutral', 50).returns(0)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('negative', 50).returns(5)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 100).returns(92)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 500).returns(80)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 1000).returns(95)
        end

        it "should change from standard_seller to good1 seller" do
          commercial_seller.seller_state = "standard_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal "good1_seller"
        end
        it "should change from good1 to good2 seller" do
          commercial_seller.seller_state = "good1_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal "good2_seller"
        end
        it "should stay good2 seller" do
          commercial_seller.seller_state = "good2_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal "good2_seller"
        end
        it "should stay good3 seller" do
          commercial_seller.seller_state = "good3_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal "good3_seller"
        end
        it "should stay good4 seller" do
          commercial_seller.seller_state = "good4_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal "good4_seller"
        end
      end

      describe "with additionally positive ratings over 90% in last 500 ratings" do
        before :each do
          commercial_seller.ratings.stubs(:count).returns 1000
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 50).returns(95)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('neutral', 50).returns(0)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('negative', 50).returns(5)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 100).returns(92)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 500).returns(92)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 1000).returns(80)
        end

        it "should change from standard_seller to good1 seller" do
          commercial_seller.seller_state = "standard_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal "good1_seller"
        end
        it "should change from good1 to good2 seller" do
          commercial_seller.seller_state = "good1_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal "good2_seller"
        end
        it "should change from good2 to good3 seller" do
          commercial_seller.seller_state = "good2_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal "good3_seller"
        end
        it "should stay good3 seller" do
          commercial_seller.seller_state = "good3_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal "good3_seller"
        end
        it "should stay good4 seller" do
          commercial_seller.seller_state = "good4_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal "good4_seller"
        end
      end

      describe "with additionally positive ratings over 90% in last 1000 ratings" do
        before :each do
          commercial_seller.ratings.stubs(:count).returns 1000
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 50).returns(95)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('neutral', 50).returns(0)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('negative', 50).returns(5)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 100).returns(92)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 500).returns(92)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 1000).returns(92)
        end

        it "should change from standard_seller to good1 seller" do
          commercial_seller.seller_state = "standard_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal "good1_seller"
        end
        it "should change from good1 to good2 seller" do
          commercial_seller.seller_state = "good1_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal "good2_seller"
        end
        it "should change from good2 to good3 seller" do
          commercial_seller.seller_state = "good2_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal "good3_seller"
        end
        it "should change from good3 to good4 seller" do
          commercial_seller.seller_state = "good3_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal "good4_seller"
        end
        it "should stay good4 seller" do
          commercial_seller.seller_state = "good4_seller"
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal "good4_seller"
        end
      end

    end
  end

end
