#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  let(:article) { Article.new }
  let(:db_article) { create(:article, :with_fixture_image) }
  let(:ngo_article) { create :article, :with_ngo }

  subject { article }

  describe 'attributes' do
    it { _(subject).must_respond_to :id }
    it { _(subject).must_respond_to :title }
    it { _(subject).must_respond_to :content }
    it { _(subject).must_respond_to :created_at }
    it { _(subject).must_respond_to :updated_at }
    it { _(subject).must_respond_to :user_id }
    it { _(subject).must_respond_to :condition }
    it { _(subject).must_respond_to :price_cents }
    it { _(subject).must_respond_to :currency }
    it { _(subject).must_respond_to :fair }
    it { _(subject).must_respond_to :fair_kind }
    it { _(subject).must_respond_to :fair_seal }
    it { _(subject).must_respond_to :ecologic }
    it { _(subject).must_respond_to :ecologic_seal }
    it { _(subject).must_respond_to :small_and_precious }
    it { _(subject).must_respond_to :small_and_precious_reason }
    it { _(subject).must_respond_to :small_and_precious_handmade }
    it { _(subject).must_respond_to :quantity }
    it { _(subject).must_respond_to :transport_details }
    it { _(subject).must_respond_to :payment_details }
    it { _(subject).must_respond_to :friendly_percent }
    it { _(subject).must_respond_to :friendly_percent_organisation }
    it { _(subject).must_respond_to :article_template_name }
    it { _(subject).must_respond_to :calculated_fair_cents }
    it { _(subject).must_respond_to :calculated_friendly_cents }
    it { _(subject).must_respond_to :calculated_fee_cents }
    it { _(subject).must_respond_to :condition_extra }
    it { _(subject).must_respond_to :small_and_precious_eu_small_enterprise }
    it { _(subject).must_respond_to :ecologic_kind }
    it { _(subject).must_respond_to :upcycling_reason }
    it { _(subject).must_respond_to :slug }
    it { _(subject).must_respond_to :transport_pickup }
    it { _(subject).must_respond_to :transport_type1 }
    it { _(subject).must_respond_to :transport_type2 }
    it { _(subject).must_respond_to :transport_type1_provider }
    it { _(subject).must_respond_to :transport_type2_provider }
    it { _(subject).must_respond_to :transport_type1_price_cents }
    it { _(subject).must_respond_to :transport_type2_price_cents }
    it { _(subject).must_respond_to :transport_time }
    it { _(subject).must_respond_to :payment_bank_transfer }
    it { _(subject).must_respond_to :payment_cash }
    it { _(subject).must_respond_to :payment_paypal }
    it { _(subject).must_respond_to :payment_invoice }
    it { _(subject).must_respond_to :payment_voucher }
    it { _(subject).must_respond_to :payment_cash_on_delivery_price_cents }
    it { _(subject).must_respond_to :basic_price_cents }
    it { _(subject).must_respond_to :basic_price_amount }
    it { _(subject).must_respond_to :state }
    it { _(subject).must_respond_to :vat }
    it { _(subject).must_respond_to :custom_seller_identifier }
    it { _(subject).must_respond_to :gtin }
    it { _(subject).must_respond_to :transport_type1_number }
    it { _(subject).must_respond_to :transport_type2_number }
    it { _(subject).must_respond_to :discount_id }
    it { _(subject).must_respond_to :transport_bike_courier }
    it { _(subject).must_respond_to :transport_bike_courier_number }

    # Statemachine state
    it { _(subject).must_respond_to :preview? }
    it { _(subject).must_respond_to :locked? }
    it { _(subject).must_respond_to :template? }
    it { _(subject).must_respond_to :sold? }
    it { _(subject).must_respond_to :active? }
    it { _(subject).must_respond_to :closed? }
  end

  describe '::Base' do
    describe 'associations' do
      should have_many :images
      should have_and_belong_to_many :categories
      should belong_to :seller
      should have_many(:business_transactions)
    end

    describe 'validations' do
      describe 'legal_entity seller' do
        subject do
          Article.new seller: LegalEntity.new, basic_price: 2
        end

        should validate_presence_of :basic_price_amount
      end

      it 'should not throw an exception when slug is already present' do
        create(:article, title: 'Great Expectations')
        another_article = Article.new(title: 'Great Expectations')
        another_article.valid?
      end
    end

    describe 'amoeba' do
      it 'should copy an article with images' do
        article = create :article, :with_fixture_image
        testpath = article.images.first.image.path # The image needs to be in place !!!
        FileUtils.mkpath File.dirname(testpath) # make the dir
        FileUtils.cp(Rails.root.join('test', 'fixtures', 'test.png'), testpath) # copy the image

        dup = article.amoeba_dup
        dup.images[0].id.wont_equal article.images[0].id
        dup.images[0].image_file_name.must_equal article.images[0].image_file_name
      end
    end

    describe 'methods' do
      describe '#owned_by?(user)' do
        it 'should return false when user is nil' do
          assert_nil article.owned_by?(nil)
        end

        it "should return false when article doesn't belong to user" do
          db_article.owned_by?(create(:user)).must_equal false
        end

        it 'should return true when article belongs to user' do
          db_article.owned_by?(db_article.seller).must_equal true
        end
      end
    end
  end

  describe '::FeesAndDonations' do
    before do
      article.seller = User.new
    end

    describe '#fee_percentage' do
      it 'should return the fair percentage when article.fair' do
        article.fair = true
        article.send('fee_percentage').must_equal 0.03
      end

      it 'should return the default percentage when !article.fair' do
        article.send('fee_percentage').must_equal 0.06
      end

      it 'should return 0 percentage when article.seller.ngo' do
        article.seller.ngo = true
        article.send('fee_percentage').must_equal 0
      end
    end

    describe '#calculate_fees_and_donations' do
      it 'should have 100 % friendly_percent for ngo' do
        ngo_article.friendly_percent.must_equal 100
      end

      # expand these unit tests!
      it 'should return zeros on fee and fair cents with a friendly_percent of gt 100' do
        article.friendly_percent = 101
        article.calculate_fees_and_donations
        article.calculated_fair.must_equal 0
        article.calculated_fee.must_equal 0
      end

      it 'should return zeros on fee and fair cents with a price of 0' do
        article.price = 0
        article.calculate_fees_and_donations
        article.calculated_fair.must_equal 0
        article.calculated_fee.must_equal 0
      end

      it 'should return the max fee when calculated_fee gt max fee' do
        article.price = 9999
        article.fair = false
        article.calculate_fees_and_donations
        article.calculated_fee.must_equal Money.new(3000)
      end

      it 'should always round the fair cents up' do
        article.price = 789.23
        article.fair = false
        article.calculate_fees_and_donations
        article.calculated_fair.must_equal Money.new(790)
      end

      it 'should be no fees for ngo' do
        article.seller.ngo = true
        article.price = 999

        article.calculate_fees_and_donations
        article.calculated_fair.must_equal 0
        article.calculated_fee.must_equal 0
      end
    end
  end

  describe '::Attributes' do
    describe 'validations' do
      it 'should throw an error if no payment option is selected' do
        article.payment_cash = false
        article.save
        article.errors[:payment_details].must_equal [I18n.t('article.form.errors.invalid_payment_option')]
      end

      it 'should throw an error if bank transfer is selected, but bank data is missing' do
        db_article.seller.stubs(:bank_account_exists?).returns(false)
        db_article.payment_bank_transfer = true
        db_article.save
        db_article.errors[:payment_bank_transfer].must_equal [I18n.t('article.form.errors.bank_details_missing')]
      end

      it 'should throw an error if paypal is selected, but bank data is missing' do
        db_article.payment_paypal = true
        db_article.save
        db_article.errors[:payment_paypal].must_equal [I18n.t('article.form.errors.paypal_details_missing')]
      end

      it 'should allow dashes in transport_time' do
        db_article.transport_time = '3 – 5'
        db_article.save
        db_article.errors[:transport_time].must_equal []
      end

      should validate_numericality_of(:transport_type1_number)
      should validate_numericality_of(:transport_type2_number)
    end

    describe 'methods' do
      describe '#selectable_transports' do
        it 'should call the private selectable function' do
          article.expects(:selectable).with('transport')
          article.selectable_transports
        end
      end

      describe '#selectable_payments' do
        it 'should call the private selectable function' do
          article.expects(:selectable).with('payment')
          article.selectable_payments
        end
      end

      describe '#selectable (private)' do
        it 'should return an array with selected transport options, the default being first' do
          output = create(:article, :with_all_payments, :with_all_transports).send(:selectable, 'transport')
          output.must_include 'pickup'
          output.must_include 'type1'
          output.must_include 'type2'
          output.must_include 'bike_courier'
        end
      end
    end
  end

  describe '::Images' do
    describe 'methods' do
      describe '#title_image_url' do
        it "should return the first image's URL when one exists" do
          db_article.title_image_url.must_match %r#/system/images/.*/original/test.png#
        end

        it 'should return the missing-image-url when no image is set' do
          article = create :article
          article.title_image_url.must_equal 'missing.png'
        end

        it "should return the first image's URL when one exists" do
          article.images = [build(:article_fixture_image), build(:article_fixture_image)]
          article.images.each do |image|
            image.is_title = true
            image.save
          end
          article.save
          article.errors[:images].must_equal [I18n.t('article.form.errors.only_one_title_image')]
        end

        it 'should return the processing image while processing when requested a thumb' do
          title_image = create(:article_image, :processing)
          db_article.images = [title_image]
          db_article.title_image_url(:thumb).must_equal title_image.image.url(:thumb)
        end

        it 'should return the original image while processing when requested a medium image' do
          title_image = create(:article_image, :processing)
          db_article.images = [title_image]
          db_article.title_image_url(:medium).must_equal title_image.original_image_url_while_processing
        end
      end

      # describe "#replace_image" do
      #   let(:article) { create :article }
      #   before {
      #     @url =
      #     article.external_image_url = "http://www.test.com/test.png" # We need to call it nowbecause else URI.stub :parse will Conflict with Fakeweb/Tire
      #   }
      #
      #   it "should do nothing if the url is already present" do
      #     URI.stubs(:parse).returns( fixture_file_upload('/test.png') )
      #     assert_difference 'Image.count', 0 do
      #       article.replace_image true, :external_image_url
      #     end
      #   end
      #
      #   it "should delete a title image if another external url is given" do
      #     URI.stubs(:parse).returns( fixture_file_upload('/test.png') )
      #     @image = ArticleImage.create(:external_url => @url, :image => nil, :is_title => true)
      #     article.images << @image
      #     @image.update_attribute(:external_url, nil)
      #     @image.expects :delete
      #     article.add_image @url, true
      #   end
      #
      #   it "should not delete a title image if the same external url is given" do
      #     URI.stubs(:parse).returns( fixture_file_upload('/test.png') )
      #     @image = ArticleImage.create(:external_url => @url, :image => nil, :is_title => true)
      #     article.images << @image
      #     @image.expects(:delete).never
      #     article.add_image @url, true
      #   end
      #
      #   it "should add an error if a timeout happens" do
      #     Timeout.expects(:timeout).raises(Timeout::Error)
      #     article.add_image @url, true
      #   end
      #
      # end
    end
  end

  describe '::Categories' do
    describe '#size_validator' do
      it 'should validate size of categories' do
        article_0cat = build :article
        article_0cat.categories = []
        article_1cat = build :article
        article_2cat = build :article, :with_child_category
        article_3cat = build :article, :with_3_categories

        article_0cat.valid?.must_equal false
        article_1cat.valid?.must_equal true
        article_2cat.valid?.must_equal true
        article_3cat.valid?.must_equal false
      end
    end
  end

  describe '::State' do
    describe 'state machine hooks:' do
      describe 'on activate' do
        it 'should calculate the fees and donations' do
          article = create :preview_article
          article.calculated_fair_cents = 0
          article.calculated_fee_cents = 0
          article.save
          article.tos_accepted = '1'
          article.activate
          article.reload.calculated_fee.must_be :>, 0
          article.calculated_fair.must_be :>, 0
        end
      end
    end
  end

  describe '::Template' do
    before do
      @article = build :article, :with_private_user, article_template_name: 'Vorlage', state: :template
    end

    describe '#save_as_template?' do
      it 'should return true when the save_as_template attribute is 1' do
        @article.save_as_template = '1'
        @article.save_as_template?.must_equal true
      end

      it 'should return false when the save_as_template attribute is 0' do
        @article.save_as_template = '0'
        @article.save_as_template?.must_equal false
      end
    end
  end
end
