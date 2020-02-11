#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  let(:user) { create(:user) }
  let(:private_stubbed) { build_stubbed(:private_user) }
  let(:le_stubbed) { build_stubbed(:legal_entity) }
  subject { User.new }

  it 'has a valid Factory' do
    user.valid?.must_equal true
  end

  describe 'attributes' do
    it { _(subject).must_respond_to :id }
    it { _(subject).must_respond_to :slug }
    it { _(subject).must_respond_to :email }
    it { _(subject).must_respond_to :encrypted_password }
    it { _(subject).must_respond_to :reset_password_token }
    it { _(subject).must_respond_to :sign_in_count }
    it { _(subject).must_respond_to :reset_password_sent_at }
    it { _(subject).must_respond_to :current_sign_in_at }
    it { _(subject).must_respond_to :last_sign_in_ip }
    it { _(subject).must_respond_to :created_at }
    it { _(subject).must_respond_to :updated_at }
    it { _(subject).must_respond_to :nickname }
    it { _(subject).must_respond_to :confirmation_token }
    it { _(subject).must_respond_to :confirmed_at }
    it { _(subject).must_respond_to :confirmation_sent_at }
    it { _(subject).must_respond_to :unconfirmed_email }
    it { _(subject).must_respond_to :banned }
    it { _(subject).must_respond_to :about_me }
    it { _(subject).must_respond_to :terms }
    it { _(subject).must_respond_to :cancellation }
    it { _(subject).must_respond_to :about }
    it { _(subject).must_respond_to :phone }
    it { _(subject).must_respond_to :mobile }
    it { _(subject).must_respond_to :fax }
    it { _(subject).must_respond_to :type }
    it { _(subject).must_respond_to :ngo }
    it { _(subject).must_respond_to :bank_account_owner }
    it { _(subject).must_respond_to :bank_account_number }
    it { _(subject).must_respond_to :bank_code }
    it { _(subject).must_respond_to :bank_name }
    it { _(subject).must_respond_to :iban }
    it { _(subject).must_respond_to :bic }
    it { _(subject).must_respond_to :paypal_account }
    it { _(subject).must_respond_to :seller_state }
    it { _(subject).must_respond_to :buyer_state }
    it { _(subject).must_respond_to :verified }
    it { _(subject).must_respond_to :bankaccount_warning }
    it { _(subject).must_respond_to :percentage_of_positive_ratings }
    it { _(subject).must_respond_to :percentage_of_negative_ratings }
    it { _(subject).must_respond_to :percentage_of_neutral_ratings }
    it { _(subject).must_respond_to :direct_debit_exemption }
    it { _(subject).must_respond_to :next_direct_debit_mandate_number }
    it { _(subject).must_respond_to :value_of_goods_cents }
    it { _(subject).must_respond_to :max_value_of_goods_cents_bonus }
    it { _(subject).must_respond_to :fastbill_subscription_id }
    it { _(subject).must_respond_to :fastbill_id }
    it { _(subject).must_respond_to :vacationing }
    it { _(subject).must_respond_to :standard_address_id }
    it { _(subject).must_respond_to :receive_comments_notification }
    it { _(subject).must_respond_to :admin }
    it { _(subject).must_respond_to :heavy_uploader }
    it { _(subject).must_respond_to :belboon_tracking_token }
    it { _(subject).must_respond_to :voluntary_contribution }
    it { _(subject).must_respond_to :invoicing_email }
    it { _(subject).must_respond_to :order_notifications_email }
    it { _(subject).must_respond_to :marketplace_owner_account }

    User.subclasses.each do |subclass|
      subject { subclass.new }

      it { _(subject).must_respond_to :max_value_of_goods_cents } # implemented on all subclasses
    end
  end

  describe 'associations' do
    should have_many(:addresses).dependent(:destroy)
    should belong_to(:standard_address)
    should have_many(:articles).dependent(:destroy)
    should have_many(:libraries).dependent(:destroy)
    should have_many(:comments).dependent(:destroy)
    should have_many(:hearts)
    should have_one(:image)
    should have_many(:seller_line_item_groups)
    should have_many(:buyer_line_item_groups)
    should have_many(:direct_debit_mandates)
  end

  describe 'validations' do
    subject { user }
    describe 'always' do
      should validate_presence_of :email
      should validate_presence_of :nickname
      should validate_uniqueness_of :nickname
    end

    describe 'on create' do
      should (validate_acceptance_of :legal).on(:create)
    end

    describe 'voluntary_contribution' do
      subject { user }
      should allow_value(nil).for :voluntary_contribution
      should allow_value(3).for :voluntary_contribution
      should allow_value(5).for :voluntary_contribution
      should allow_value(10).for :voluntary_contribution
      should_not allow_value(6).for :voluntary_contribution
      should_not allow_value(-1).for :voluntary_contribution
    end

    describe 'on update' do
      describe 'zip code validation' do
        before :each do
          user.standard_address.country = 'Deutschland'
        end

        subject { user.standard_address }

        should allow_value('12345').for :zip
        should_not allow_value('a1b2c').for :zip
        should_not allow_value('123456').for :zip
        should_not allow_value('1234').for :zip
      end

      describe 'address validation' do
        subject { user.standard_address }
        should allow_value('Test Str. 1a').for :address_line_1
        should_not allow_value('Test Str.').for :address_line_1
      end
    end

    describe 'if user wants to sell' do
      subject { user.standard_address }
      before :each do
        user.wants_to_sell = true
      end
      should validate_presence_of :first_name
      should validate_presence_of :last_name
      should validate_presence_of :address_line_1
      should validate_presence_of :zip
      should validate_presence_of :city
      should validate_presence_of :country
    end

    describe 'if legal entity wants to sell' do
      subject { le_stubbed }

      before :each do
        le_stubbed.wants_to_sell = true
        le_stubbed.direct_debit_exemption = false
        le_stubbed.standard_address = build_stubbed(:address_for_alice)
      end

      should validate_presence_of :iban
      should validate_presence_of :bic
      should validate_presence_of :bank_account_owner

      it 'should validate presence of active direct debit mandate' do
        le_stubbed.stubs(:has_active_direct_debit_mandate?).returns(true)
        assert le_stubbed.valid?
      end
    end

    describe 'if legal entity that is exempted from direct debit wants to sell' do
      before :each do
        le_stubbed.wants_to_sell = true
        le_stubbed.direct_debit_exemption = true
        le_stubbed.standard_address = build_stubbed(:address_for_alice)
      end

      should_not validate_presence_of :iban
      should_not validate_presence_of :bic
      should_not validate_presence_of :bank_account_owner

      it 'must not validate presence of active direct debit mandate' do
        le_stubbed.stubs(:has_active_direct_debit_mandate?).returns(false)
        assert le_stubbed.valid?
      end
    end
  end

  describe 'banning a user' do
    it 'should deactivate all of users active articles' do
      user = create :user
      create :article, seller: user

      assert_difference 'user.articles.active.count', -1, 'active articles of user shoud be deactivated' do
        user.banned = true
        user.save
      end
    end
  end

  describe 'marketplace_owner_account' do
    it 'should be false for new User instances' do
      user = User.new
      user.marketplace_owner_account.must_equal false
    end
  end

  describe '#needs_to_be_billed?' do
    it 'should be true for legal entities' do
      alice = build_stubbed :user_alice
      assert alice.needs_to_be_billed?
    end

    it 'should be false for private users' do
      bob = build_stubbed :user_bob
      refute bob.needs_to_be_billed?
    end

    it 'should be false for legal entities that are ngos' do
      dave = build_stubbed :user_dave
      refute dave.needs_to_be_billed?
    end

    it 'should be false for legal entities that are accounts of the marketplace owner' do
      eve = build_stubbed :user_eve
      refute eve.needs_to_be_billed?
    end
  end

  describe 'direct debit exemption' do
    it 'should be false for new User instances' do
      le = User.new
      le.direct_debit_exemption.must_equal false
    end
  end

  describe 'next direct debit mandate number' do
    it 'should be 1 for new User instances' do
      user = User.new
      user.next_direct_debit_mandate_number.must_equal 1
    end
  end

  describe 'methods' do
    describe '#count_value_of_goods' do
      it 'should sum the value of active goods' do
        article = create :article, seller: user
        second_article = create :article, seller: user
        user.articles.reload
        user.count_value_of_goods
        user.value_of_goods_cents.must_equal(article.price_cents + second_article.price_cents)
      end

      it 'should not sum the value of inactive goods' do
        create :preview_article, seller: user
        user.count_value_of_goods
        user.value_of_goods_cents.must_equal 0
      end
    end

    describe '#fullname' do
      it 'returns correct fullname' do
        user.fullname.must_equal "#{user.standard_address_first_name} #{user.standard_address_last_name}"
      end
    end

    describe '#name' do
      it 'returns correct name' do
        user.name.must_equal user.nickname
      end
    end

    describe '#is?' do
      it 'should return true when users have the same ID' do
        user.is?(user).must_equal true
      end

      it "should return false when users don't have the same ID" do
        user.is?(create(:user)).must_equal false
      end
    end

    describe '#customer_nr' do
      let(:user) { build(:user, id: 1) }

      it 'should have 8 digits' do
        user.customer_nr.length.must_equal 8
      end

      it 'should use the user_id' do
        user.customer_nr.must_equal "00000001"
      end
    end

    describe 'paypal_account_exists?' do
      it 'should be true if user has paypal account' do
        create(:user, :paypal_data).paypal_account_exists?.must_equal true
      end
      it 'should be false if user does not have paypal account' do
        user.paypal_account_exists?.must_equal false
      end
    end

    describe 'bank_account_exists?' do
      it 'should be true if user has bank account' do
        user.bank_account_exists?.must_equal true
      end
      it 'should be false if user does not have bank account' do
        create(:user, :no_bank_data).bank_account_exists?.must_equal false
      end
    end

    describe 'bank_details_valid?' do
      it 'should return true if KontoAPI check succeeds' do
        le_stubbed.bank_details_valid?.must_equal true
      end

      it 'should return false if KontoAPI check fails' do
        KontoAPI.stubs(:valid?).returns(false)
        le_stubbed.bank_details_valid?.must_equal false
      end
    end

    describe '#payment_method' do
      describe 'when no direct debit mandate is available' do
        before do
          @alice = build_stubbed :user_alice
          @alice.stubs(:has_active_direct_debit_mandate?).returns(false)
        end

        it 'should return invoice' do
          @alice.bankaccount_warning = false

          @alice.payment_method.must_equal :payment_by_invoice
        end
      end

      describe 'when a direct debit mandate is available' do
        before do
          @alice = build_stubbed :user_alice
          @alice.stubs(:has_active_direct_debit_mandate?).returns(true)
        end

        it 'should return direct debit if bank details are valid' do
          @alice.bankaccount_warning = false

          @alice.payment_method.must_equal :payment_by_direct_debit
        end

        it 'should return invoice if bank details are not valid' do
          @alice.bankaccount_warning = true

          @alice.payment_method.must_equal :payment_by_invoice
        end
      end
    end

    describe '#increase_direct_debit_mandate_number' do
      it 'should return the next direct debit mandate number and increase it afterwards' do
        alice = build_stubbed :user_alice, next_direct_debit_mandate_number: 1
        num1 = alice.increase_direct_debit_mandate_number

        assert_equal(1, num1)
        assert_equal(2, alice.next_direct_debit_mandate_number)
      end
    end

    describe '#requires_direct_debit_mandate?' do
      let(:alice) { build_stubbed :user_alice }
      let(:bob) { build_stubbed :user_bob }

      it 'should return false if direct debit exemption is true' do
        alice.stubs(:direct_debit_exemption).returns(true)

        refute alice.requires_direct_debit_mandate?
      end

      it 'should return false if user is a private user' do
        refute bob.requires_direct_debit_mandate?
      end

      it 'should return false if user already has an active mandate' do
        alice.stubs(:has_active_direct_debit_mandate?).returns(true)

        refute alice.requires_direct_debit_mandate?
      end

      it 'should return false if user has no articles' do
        refute alice.requires_direct_debit_mandate?
      end

      it 'should be true for legal entities without mandates who do have articles' do
        alice.stubs(:has_articles?).returns(:true)

        assert alice.requires_direct_debit_mandate?
      end
    end

    describe '#has_articles?' do
      let(:alice) { create :user_alice_with_bank_details }

      it 'should return false if user has no articles' do
        refute alice.has_articles?
      end

      it 'should return 1 if user has one article' do
        create :article, seller: alice

        assert alice.has_articles?
      end
    end

    describe '#has_active_direct_debit_mandate?' do
      let(:alice) { build_stubbed :user_alice }

      it 'should return true if an active mandate is present' do
        mandate = build_stubbed :direct_debit_mandate_wo_user, user: alice
        alice.stubs(:active_direct_debit_mandate).returns(mandate)

        assert alice.has_active_direct_debit_mandate?
      end

      it 'should return false if no active mandate is present' do
        alice.stubs(:active_direct_debit_mandate).returns(nil)

        refute alice.has_active_direct_debit_mandate?
      end
    end

    describe '#active_direct_debit_mandate' do
      it 'should return an active mandate if one is present' do
        alice = create :user_alice
        mandate = create :direct_debit_mandate_wo_user, user: alice
        mandate.activate!

        alice.active_direct_debit_mandate.must_equal mandate
      end

      it 'should return nil if no active mandate is present' do
        alice = create :user_alice
        create :direct_debit_mandate_wo_user, user: alice

        alice.active_direct_debit_mandate.must_be_nil
      end

      it 'should return nil if no mandate is present' do
        alice = build_stubbed :user_alice

        alice.active_direct_debit_mandate.must_be_nil
      end
    end

    describe '#update_fastbill_profile' do
      let(:user) { create :legal_entity, :fastbill }
      let(:api) { FastbillAPI.new }

      it 'should call FastBillAPI.update_profile if user has fastbill profile' do
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

    describe '#calculate_percentage_of_biased_ratings' do
      before :each do
        last_ratings = []
        7.times { last_ratings << Rating.new(rating: 'positive') }
        1.times { last_ratings << Rating.new(rating: 'negative') }
        2.times { last_ratings << Rating.new(rating: 'neutral') }

        limit_mock = mock
        limit_mock.stubs(:limit).returns(last_ratings)
        select_mock = mock
        select_mock.stubs(:select).returns(limit_mock)
        user.stubs(:ratings).returns(select_mock)
      end

      it 'should be calculated correctly for positive ratings' do
        user.calculate_percentage_of_biased_ratings('positive', 10).must_equal 70.0
      end
      it 'should be calculated correctly for negative ratings' do
        user.calculate_percentage_of_biased_ratings('negative', 10).must_equal 10.0
      end
    end

    describe '#email_for_invoicing' do
      it 'for legal entities, should use invoicing email if present' do
        le_stubbed.email_for_invoicing.must_equal le_stubbed.invoicing_email
      end

      it 'for legal entities, should use standard email if no invoicing email is present' do
        le_stubbed.invoicing_email = ''
        le_stubbed.email_for_invoicing.must_equal le_stubbed.email
      end

      it 'for private users, should use standard email if no invoicing email is present' do
        private_stubbed.email_for_invoicing.must_equal private_stubbed.email
      end

      it 'for private users, should use standard email even if invoicing email is present' do
        private_stubbed.invoicing_email = 'invoices@example.com'
        private_stubbed.email_for_invoicing.must_equal private_stubbed.email
      end
    end

    describe '#email_for_order_notifications' do
      it 'for legal entities, should use order notifications email if present' do
        le_stubbed.email_for_order_notifications.must_equal le_stubbed.order_notifications_email
      end

      it 'for legal entities, should use standard email if no order notifications email is present' do
        le_stubbed.order_notifications_email = ''
        le_stubbed.email_for_order_notifications.must_equal le_stubbed.email
      end

      it 'for private users, should use standard email if no order notifications email is present' do
        private_stubbed.email_for_order_notifications.must_equal private_stubbed.email
      end

      it 'for private users, should use standard email even if order notifications email is present' do
        private_stubbed.order_notifications_email = 'orders@example.com'
        private_stubbed.email_for_order_notifications.must_equal private_stubbed.email
      end
    end
  end

  describe 'subclasses' do
    describe PrivateUser do
      let(:user) { create(:private_user) }

      it 'should have a valid factory' do
        user.valid?.must_equal true
      end

      it 'should return the same model_name as User' do
        PrivateUser.model_name.must_equal User.model_name
      end
    end

    describe LegalEntity do
      let(:db_user) { build_stubbed(:legal_entity) }

      it 'should have a valid factory' do
        db_user.valid?.must_equal true
      end

      it 'should return the same model_name as User' do
        LegalEntity.model_name.must_equal User.model_name
      end

      describe 'validations' do
        describe 'if LegalEntity wants to sell' do
          subject { db_user }

          before :each do
            db_user.wants_to_sell = true
          end

          should validate_presence_of :terms
          should validate_presence_of :cancellation
          should validate_presence_of :about
        end
      end
    end
  end

  describe 'seller states' do
    describe PrivateUser do
      let(:private_seller) { create(:private_user) }

      describe 'bad seller' do
        before :each do
          private_seller.seller_state = 'bad_seller'
        end

        it 'should become standard seller' do
          private_seller.rate_up
          private_seller.standard_seller?.must_equal true
        end

        it 'should have a salesvolume of bad_salesvolume if not verified' do
          private_seller.verified = false
          private_seller.max_value_of_goods_cents.must_equal PRIVATE_SELLER_CONSTANTS['bad_salesvolume']
        end

        it 'should have a salesvolume of 17 if verified' do
          private_seller.verified = true
          private_seller.max_value_of_goods_cents.must_equal PRIVATE_SELLER_CONSTANTS['bad_salesvolume']
        end

        it 'should have a salesvolume of 17 if verified' do
          private_seller.verified = true
          private_seller.max_value_of_goods_cents.must_equal PRIVATE_SELLER_CONSTANTS['bad_salesvolume']
        end
      end # /bad seller

      describe 'standard seller' do
        before :each do
          private_seller.seller_state = 'standard_seller'
        end

        it 'should become good seller' do
          private_seller.rate_up
          private_seller.good_seller?.must_equal true
        end

        it 'should have a salesvolume of standard_salesvolume if not verified' do
          private_seller.verified = false
          private_seller.max_value_of_goods_cents.must_equal PRIVATE_SELLER_CONSTANTS['standard_salesvolume']
        end

        it 'should have a salesvolume of standard_salesvolume + verified_bonus if verified' do
          private_seller.verified = true
          private_seller.max_value_of_goods_cents.must_equal(PRIVATE_SELLER_CONSTANTS['standard_salesvolume'] + PRIVATE_SELLER_CONSTANTS['verified_bonus'])
        end

        it 'should have a salesvolume of standard_salesvolume + verified_bonus if verified' do
          private_seller.verified = true
          private_seller.max_value_of_goods_cents.must_equal(PRIVATE_SELLER_CONSTANTS['standard_salesvolume'] + PRIVATE_SELLER_CONSTANTS['verified_bonus'])
        end
      end # /standard seller

      describe 'good seller' do
        before :each do
          private_seller.seller_state = 'good_seller'
        end

        it 'should have a salesvolume of standard_salesvolume * good_factor if not verified' do
          private_seller.verified = false
          private_seller.max_value_of_goods_cents.must_equal(PRIVATE_SELLER_CONSTANTS['standard_salesvolume'] * PRIVATE_SELLER_CONSTANTS['good_factor'])
        end

        it 'should have a salesvolume of (standard_salesvolume + verified_bonus ) * good_factor if verified' do
          private_seller.verified = true
          private_seller.max_value_of_goods_cents.must_equal((PRIVATE_SELLER_CONSTANTS['standard_salesvolume'] + PRIVATE_SELLER_CONSTANTS['verified_bonus']) * PRIVATE_SELLER_CONSTANTS['good_factor'])
        end

        it 'should have a salesvolume of (standard_salesvolume + verified_bonus ) * good_factor if verified' do
          private_seller.verified = true
          private_seller.max_value_of_goods_cents.must_equal((PRIVATE_SELLER_CONSTANTS['standard_salesvolume'] + PRIVATE_SELLER_CONSTANTS['verified_bonus']) * PRIVATE_SELLER_CONSTANTS['good_factor'])
        end
      end # /good seller

      it 'should have valid private_seller_constants' do
        private_seller.private_seller_constants[:standard_salesvolume].must_equal PRIVATE_SELLER_CONSTANTS['standard_salesvolume']
        private_seller.private_seller_constants[:verified_bonus].must_equal PRIVATE_SELLER_CONSTANTS['verified_bonus']
        private_seller.private_seller_constants[:good_factor].must_equal PRIVATE_SELLER_CONSTANTS['good_factor']
        private_seller.private_seller_constants[:bad_salesvolume].must_equal PRIVATE_SELLER_CONSTANTS['bad_salesvolume']
      end
    end

    describe LegalEntity do
      let(:commercial_seller) { create(:legal_entity) }
      subject { commercial_seller }

      describe 'bad seller' do
        before :each do
          commercial_seller.seller_state = 'bad_seller'
        end

        it 'should become standard seller' do
          commercial_seller.rate_up
          commercial_seller.standard_seller?.must_equal true
        end

        it 'should have a salesvolume of bad_salesvolume if not verified' do
          commercial_seller.verified = false
          commercial_seller.max_value_of_goods_cents.must_equal COMMERCIAL_SELLER_CONSTANTS['bad_salesvolume']
        end

        it 'should have a salesvolume of bad_salesvolume if verified' do
          commercial_seller.verified = true
          commercial_seller.max_value_of_goods_cents.must_equal COMMERCIAL_SELLER_CONSTANTS['bad_salesvolume']
        end
      end # /bad seller

      describe 'standard seller' do
        before :each do
          commercial_seller.seller_state = 'standard_seller'
        end

        it 'should become good1 seller' do
          commercial_seller.rate_up
          commercial_seller.good1_seller?.must_equal true
        end

        it 'should have a salesvolume of standard_salesvolume if not verified' do
          commercial_seller.verified = false
          commercial_seller.max_value_of_goods_cents.must_equal COMMERCIAL_SELLER_CONSTANTS['standard_salesvolume']
        end

        it 'should have a salesvolume of standard_salesvolume + verified_bonus if verified' do
          commercial_seller.verified = true
          commercial_seller.max_value_of_goods_cents.must_equal(COMMERCIAL_SELLER_CONSTANTS['standard_salesvolume'] + COMMERCIAL_SELLER_CONSTANTS['verified_bonus'])
        end
      end # /standard seller

      describe 'good1 seller' do
        before :each do
          commercial_seller.seller_state = 'good1_seller'
        end

        it 'should become good2 seller' do
          commercial_seller.rate_up
          commercial_seller.good2_seller?.must_equal true
        end

        it 'should have a salesvolume of standard_salesvolume * good_factor if not verified' do
          commercial_seller.verified = false
          commercial_seller.max_value_of_goods_cents.must_equal COMMERCIAL_SELLER_CONSTANTS['standard_salesvolume'] * COMMERCIAL_SELLER_CONSTANTS['good_factor']
        end

        it 'should have a salesvolume of ( standard_salesvolume + verified_bonus ) * good_factor if verified' do
          commercial_seller.verified = true
          commercial_seller.max_value_of_goods_cents.must_equal((COMMERCIAL_SELLER_CONSTANTS['standard_salesvolume'] + COMMERCIAL_SELLER_CONSTANTS['verified_bonus']) * COMMERCIAL_SELLER_CONSTANTS['good_factor'])
        end
      end # /good1 seller

      describe 'good2 seller' do
        before :each do
          commercial_seller.seller_state = 'good2_seller'
        end

        it 'should be able to rate to good3 seller' do
          commercial_seller.rate_up
          commercial_seller.good3_seller?.must_equal true
        end

        it 'should have a salesvolume of standard_salesvolume * good_factor^2 if not verified' do
          commercial_seller.verified = false
          commercial_seller.max_value_of_goods_cents.must_equal COMMERCIAL_SELLER_CONSTANTS['standard_salesvolume'] * (COMMERCIAL_SELLER_CONSTANTS['good_factor']**2)
        end

        it 'should have a salesvolume of ( standard_salesvolume + verified_bonus ) * good_factor^2 if verified' do
          commercial_seller.verified = true
          commercial_seller.max_value_of_goods_cents.must_equal((COMMERCIAL_SELLER_CONSTANTS['standard_salesvolume'] + COMMERCIAL_SELLER_CONSTANTS['verified_bonus']) * (COMMERCIAL_SELLER_CONSTANTS['good_factor']**2))
        end
      end # /good2 seller

      describe 'good3 seller' do
        before :each do
          commercial_seller.seller_state = 'good3_seller'
        end

        it 'should become good4 seller' do
          commercial_seller.rate_up
          commercial_seller.good4_seller?.must_equal true
        end

        it 'should have a salesvolume of standard_salesvolume * good_factor^3 if not verified' do
          commercial_seller.verified = false
          commercial_seller.max_value_of_goods_cents.must_equal COMMERCIAL_SELLER_CONSTANTS['standard_salesvolume'] * (COMMERCIAL_SELLER_CONSTANTS['good_factor']**3)
        end

        it 'should have a salesvolume of ( standard_salesvolume + verified_bonus ) * good_factor^3 if verified' do
          commercial_seller.verified = true
          commercial_seller.max_value_of_goods_cents.must_equal((COMMERCIAL_SELLER_CONSTANTS['standard_salesvolume'] + COMMERCIAL_SELLER_CONSTANTS['verified_bonus']) * (COMMERCIAL_SELLER_CONSTANTS['good_factor']**3))
        end
      end # /good3 seller

      describe 'good4 seller' do
        before :each do
          commercial_seller.seller_state = 'good4_seller'
        end

        it 'should have a salesvolume of standard_salesvolume * good_factor^4 if not verified' do
          commercial_seller.verified = false
          commercial_seller.max_value_of_goods_cents.must_equal COMMERCIAL_SELLER_CONSTANTS['standard_salesvolume'] * (COMMERCIAL_SELLER_CONSTANTS['good_factor']**4)
        end

        it 'should have a salesvolume of ( standard_salesvolume + verified_bonus ) * good_factor^4 if verified' do
          commercial_seller.verified = true
          commercial_seller.max_value_of_goods_cents.must_equal((COMMERCIAL_SELLER_CONSTANTS['standard_salesvolume'] + COMMERCIAL_SELLER_CONSTANTS['verified_bonus']) * (COMMERCIAL_SELLER_CONSTANTS['good_factor']**4))
        end
      end # /good4 seller

      it 'should have valid commercial_seller_constants' do
        commercial_seller.commercial_seller_constants[:standard_salesvolume].must_equal COMMERCIAL_SELLER_CONSTANTS['standard_salesvolume']
        commercial_seller.commercial_seller_constants[:verified_bonus].must_equal COMMERCIAL_SELLER_CONSTANTS['verified_bonus']
        commercial_seller.commercial_seller_constants[:good_factor].must_equal COMMERCIAL_SELLER_CONSTANTS['good_factor']
        commercial_seller.commercial_seller_constants[:bad_salesvolume].must_equal COMMERCIAL_SELLER_CONSTANTS['bad_salesvolume']
      end
    end
  end # /seller states

  describe 'buyer_states' do
    describe 'bad buyer' do
      before :each do
        user.buyer_state = 'bad_buyer'
      end

      it 'should become standard buyer' do
        user.rate_up_buyer
        user.standard_buyer?.must_equal true
      end
    end

    describe 'standard buyer' do
      before :each do
        user.buyer_state = 'standard_buyer'
      end

      it 'should become bad buyer' do
        user.rate_down_to_bad_buyer
        user.bad_buyer?.must_equal true
      end

      it 'should become good buyer' do
        user.rate_up_buyer
        user.good_buyer?.must_equal true
      end
    end

    describe 'good buyer' do
      before :each do
        user.buyer_state = 'good_buyer'
      end

      it 'should become bad buyer' do
        user.rate_down_to_bad_buyer
        user.bad_buyer?.must_equal true
      end
    end

    it 'should have valid buyer_constants' do
      user.buyer_constants[:not_registered_purchasevolume].must_equal 4
      user.buyer_constants[:standard_purchasevolume].must_equal 12
      user.buyer_constants[:bad_purchasevolume].must_equal 6
      user.buyer_constants[:good_factor].must_equal 2
    end
  end # /buyer states

  describe 'seller rating' do
    describe PrivateUser do
      let(:private_seller) { create(:private_user) }

      describe 'with negative ratings over 25%' do
        before :each do
          private_seller.ratings.stubs(:count).returns 21
          private_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 50).returns(50)
          private_seller.stubs(:calculate_percentage_of_biased_ratings).with('neutral', 50).returns(20)
          private_seller.stubs(:calculate_percentage_of_biased_ratings).with('negative', 50).returns(30)
        end

        it 'should change percentage of negative ratings' do
          private_seller.update_rating_counter
          private_seller.percentage_of_negative_ratings.must_equal 30.0
        end
        it 'should change from good to bad seller' do
          private_seller.seller_state = 'good_seller'
          private_seller.update_rating_counter
          private_seller.seller_state.must_equal 'bad_seller'
        end
        it 'should change from standard to bad seller' do
          private_seller.seller_state = 'standard_seller'
          private_seller.update_rating_counter
          private_seller.seller_state.must_equal 'bad_seller'
        end
        it 'should stay bad seller' do
          private_seller.seller_state = 'bad_seller'
          private_seller.update_rating_counter
          private_seller.seller_state.must_equal 'bad_seller'
        end
      end

      describe 'with negative ratings over 50%' do
        before :each do
          private_seller.ratings.stubs(:count).returns 21
          private_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 50).returns(10)
          private_seller.stubs(:calculate_percentage_of_biased_ratings).with('neutral', 50).returns(25)
          private_seller.stubs(:calculate_percentage_of_biased_ratings).with('negative', 50).returns(55)
        end

        it 'should mark the user as banned' do
          private_seller.update_rating_counter
          private_seller.banned.must_equal true
        end
      end

      describe 'with positive ratings over 75%' do
        before :each do
          private_seller.ratings.stubs(:count).returns 21
          private_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 50).returns(80)
          private_seller.stubs(:calculate_percentage_of_biased_ratings).with('neutral', 50).returns(10)
          private_seller.stubs(:calculate_percentage_of_biased_ratings).with('negative', 50).returns(10)
        end

        it 'should change percentage of positive ratings' do
          private_seller.update_rating_counter
          private_seller.percentage_of_positive_ratings.must_equal 80.0
        end
        it 'should stay good seller' do
          private_seller.seller_state = 'good_seller'
          private_seller.update_rating_counter
          private_seller.seller_state.must_equal 'good_seller'
        end
        it 'should stay standard seller' do
          private_seller.seller_state = 'standard_seller'
          private_seller.update_rating_counter
          private_seller.seller_state.must_equal 'standard_seller'
        end
        it 'should change from bad to standard seller' do
          private_seller.seller_state = 'bad_seller'
          private_seller.update_rating_counter
          private_seller.seller_state.must_equal 'standard_seller'
        end
      end

      describe 'with positive ratings over 90%' do
        before :each do
          private_seller.ratings.stubs(:count).returns 21
          private_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 50).returns(92)
          private_seller.stubs(:calculate_percentage_of_biased_ratings).with('neutral', 50).returns(0)
          private_seller.stubs(:calculate_percentage_of_biased_ratings).with('negative', 50).returns(8)
        end

        it 'should stay good seller' do
          private_seller.seller_state = 'good_seller'
          private_seller.update_rating_counter
          private_seller.seller_state.must_equal 'good_seller'
        end
        it 'should change from standard to good seller' do
          private_seller.seller_state = 'standard_seller'
          private_seller.update_rating_counter
          private_seller.seller_state.must_equal 'good_seller'
        end
        it 'should change from bad_seller to standard_seller' do
          private_seller.seller_state = 'bad_seller'
          private_seller.update_rating_counter
          private_seller.seller_state.must_equal 'standard_seller'
        end
      end
    end

    describe LegalEntity do
      let(:commercial_seller) { create(:legal_entity) }

      describe 'with negative ratings over 25%' do
        before :each do
          commercial_seller.ratings.stubs(:count).returns 1000
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 50).returns(50)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('neutral', 50).returns(20)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('negative', 50).returns(30)
        end

        it 'should change from good1 to bad seller' do
          commercial_seller.seller_state = 'good1_seller'
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal 'bad_seller'
        end
        it 'should change from good2 to bad seller' do
          commercial_seller.seller_state = 'good2_seller'
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal 'bad_seller'
        end
        it 'should change from good3 to bad seller' do
          commercial_seller.seller_state = 'good3_seller'
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal 'bad_seller'
        end
        it 'should change from good4 to bad seller' do
          commercial_seller.seller_state = 'good4_seller'
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal 'bad_seller'
        end
        it 'should change from standard to bad seller' do
          commercial_seller.seller_state = 'standard_seller'
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal 'bad_seller'
        end
        it 'should stay bad seller' do
          commercial_seller.seller_state = 'bad_seller'
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal 'bad_seller'
        end
      end

      describe 'with negative ratings over 50%' do
        before :each do
          commercial_seller.ratings.stubs(:count).returns 1000
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 50).returns(10)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('neutral', 50).returns(25)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('negative', 50).returns(55)
        end

        it 'should mark the user as banned' do
          commercial_seller.update_rating_counter
          commercial_seller.banned.must_equal true
        end
      end

      describe 'with positive ratings over 75%' do
        before :each do
          commercial_seller.ratings.stubs(:count).returns 1000
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 50).returns(80)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('neutral', 50).returns(5)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('negative', 50).returns(15)
        end

        it 'should change from bad to standard seller' do
          commercial_seller.seller_state = 'bad_seller'
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal 'standard_seller'
        end
        it 'should stay standard seller' do
          commercial_seller.seller_state = 'standard_seller'
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal 'standard_seller'
        end
        it 'should stay good1 seller' do
          commercial_seller.seller_state = 'good1_seller'
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal 'good1_seller'
        end
        it 'should stay good2 seller' do
          commercial_seller.seller_state = 'good2_seller'
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal 'good2_seller'
        end
        it 'should stay good3 seller' do
          commercial_seller.seller_state = 'good3_seller'
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal 'good3_seller'
        end
        it 'should stay good4 seller' do
          commercial_seller.seller_state = 'good4_seller'
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal 'good4_seller'
        end
      end

      describe 'with positive ratings over 90% in last 50 ratings' do
        before :each do
          commercial_seller.ratings.stubs(:count).returns 1000
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 50).returns(92)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('neutral', 50).returns(0)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('negative', 50).returns(8)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 100).returns(80)
        end

        it 'should change from standard to good1 seller' do
          commercial_seller.seller_state = 'standard_seller'
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal 'good1_seller'
        end
        it 'should stay good1 seller' do
          commercial_seller.seller_state = 'good1_seller'
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal 'good1_seller'
        end
        it 'should stay good2 seller' do
          commercial_seller.seller_state = 'good2_seller'
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal 'good2_seller'
        end
        it 'should stay good3 seller' do
          commercial_seller.seller_state = 'good3_seller'
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal 'good3_seller'
        end
        it 'should stay good4 seller' do
          commercial_seller.seller_state = 'good4_seller'
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal 'good4_seller'
        end
      end

      describe 'with additionally positive ratings over 90% in last 100 ratings' do
        before :each do
          commercial_seller.ratings.stubs(:count).returns 1000
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 50).returns(95)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('neutral', 50).returns(0)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('negative', 50).returns(5)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 100).returns(92)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 500).returns(80)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 1000).returns(95)
        end

        it 'should change from standard_seller to good1 seller' do
          commercial_seller.seller_state = 'standard_seller'
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal 'good1_seller'
        end
        it 'should change from good1 to good2 seller' do
          commercial_seller.seller_state = 'good1_seller'
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal 'good2_seller'
        end
        it 'should stay good2 seller' do
          commercial_seller.seller_state = 'good2_seller'
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal 'good2_seller'
        end
        it 'should stay good3 seller' do
          commercial_seller.seller_state = 'good3_seller'
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal 'good3_seller'
        end
        it 'should stay good4 seller' do
          commercial_seller.seller_state = 'good4_seller'
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal 'good4_seller'
        end
      end

      describe 'with additionally positive ratings over 90% in last 500 ratings' do
        before :each do
          commercial_seller.ratings.stubs(:count).returns 1000
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 50).returns(95)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('neutral', 50).returns(0)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('negative', 50).returns(5)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 100).returns(92)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 500).returns(92)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 1000).returns(80)
        end

        it 'should change from standard_seller to good1 seller' do
          commercial_seller.seller_state = 'standard_seller'
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal 'good1_seller'
        end
        it 'should change from good1 to good2 seller' do
          commercial_seller.seller_state = 'good1_seller'
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal 'good2_seller'
        end
        it 'should change from good2 to good3 seller' do
          commercial_seller.seller_state = 'good2_seller'
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal 'good3_seller'
        end
        it 'should stay good3 seller' do
          commercial_seller.seller_state = 'good3_seller'
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal 'good3_seller'
        end
        it 'should stay good4 seller' do
          commercial_seller.seller_state = 'good4_seller'
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal 'good4_seller'
        end
      end

      describe 'with additionally positive ratings over 90% in last 1000 ratings' do
        before :each do
          commercial_seller.ratings.stubs(:count).returns 1000
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 50).returns(95)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('neutral', 50).returns(0)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('negative', 50).returns(5)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 100).returns(92)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 500).returns(92)
          commercial_seller.stubs(:calculate_percentage_of_biased_ratings).with('positive', 1000).returns(92)
        end

        it 'should change from standard_seller to good1 seller' do
          commercial_seller.seller_state = 'standard_seller'
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal 'good1_seller'
        end
        it 'should change from good1 to good2 seller' do
          commercial_seller.seller_state = 'good1_seller'
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal 'good2_seller'
        end
        it 'should change from good2 to good3 seller' do
          commercial_seller.seller_state = 'good2_seller'
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal 'good3_seller'
        end
        it 'should change from good3 to good4 seller' do
          commercial_seller.seller_state = 'good3_seller'
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal 'good4_seller'
        end
        it 'should stay good4 seller' do
          commercial_seller.seller_state = 'good4_seller'
          commercial_seller.update_rating_counter
          commercial_seller.seller_state.must_equal 'good4_seller'
        end
      end
    end
  end
end
