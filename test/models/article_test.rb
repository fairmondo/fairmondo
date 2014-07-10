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

describe Article do

  let(:article) { Article.new }
  let(:db_article) { FactoryGirl.create(:article) }
  let(:ngo_article) { FactoryGirl.create :article, :with_ngo }

  subject { article }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :title }
    it { subject.must_respond_to :content }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
    it { subject.must_respond_to :user_id }
    it { subject.must_respond_to :condition }
    it { subject.must_respond_to :price_cents }
    it { subject.must_respond_to :currency }
    it { subject.must_respond_to :fair }
    it { subject.must_respond_to :fair_kind }
    it { subject.must_respond_to :fair_seal }
    it { subject.must_respond_to :ecologic }
    it { subject.must_respond_to :ecologic_seal }
    it { subject.must_respond_to :small_and_precious }
    it { subject.must_respond_to :small_and_precious_reason }
    it { subject.must_respond_to :small_and_precious_handmade }
    it { subject.must_respond_to :quantity }
    it { subject.must_respond_to :transport_details }
    it { subject.must_respond_to :payment_details }
    it { subject.must_respond_to :friendly_percent }
    it { subject.must_respond_to :friendly_percent_organisation }
    it { subject.must_respond_to :template_name }
    it { subject.must_respond_to :calculated_fair_cents }
    it { subject.must_respond_to :calculated_friendly_cents }
    it { subject.must_respond_to :calculated_fee_cents }
    it { subject.must_respond_to :condition_extra }
    it { subject.must_respond_to :small_and_precious_eu_small_enterprise }
    it { subject.must_respond_to :ecologic_kind }
    it { subject.must_respond_to :upcycling_reason }
    it { subject.must_respond_to :slug }
    it { subject.must_respond_to :transport_pickup }
    it { subject.must_respond_to :transport_type1 }
    it { subject.must_respond_to :transport_type2 }
    it { subject.must_respond_to :transport_type1_provider }
    it { subject.must_respond_to :transport_type2_provider }
    it { subject.must_respond_to :transport_type1_price_cents }
    it { subject.must_respond_to :transport_type2_price_cents }
    it { subject.must_respond_to :payment_bank_transfer }
    it { subject.must_respond_to :payment_cash }
    it { subject.must_respond_to :payment_paypal }
    it { subject.must_respond_to :payment_invoice }
    it { subject.must_respond_to :payment_cash_on_delivery_price_cents }
    it { subject.must_respond_to :basic_price_cents }
    it { subject.must_respond_to :basic_price_amount }
    it { subject.must_respond_to :state }
    it { subject.must_respond_to :vat }
    it { subject.must_respond_to :custom_seller_identifier }
    it { subject.must_respond_to :gtin }
    it { subject.must_respond_to :transport_type1_number }
    it { subject.must_respond_to :transport_type2_number }
    it { subject.must_respond_to :discount_id }
  end

  describe "::Base" do
    describe "associations" do
      it {subject.must have_many :images}
      it {subject.must have_and_belong_to_many :categories}
      it {subject.must belong_to :seller}
      it {subject.must have_many(:business_transactions)}
    end

    describe "validations" do
      describe "legal_entity seller" do
        let (:special_article) { a = Article.new
                  a.seller = LegalEntity.new
                  a.basic_price = 2
                  a }
        it { special_article.must validate_presence_of :basic_price_amount }
      end

    end

    describe "amoeba" do
      it "should copy an article with images" do
        article = FactoryGirl.create :article, :with_fixture_image
        testpath = article.images.first.image.path # The image needs to be in place !!!
        FileUtils.mkpath File.dirname(testpath) # make the dir
        FileUtils.cp(Rails.root.join('test', 'fixtures', 'test.png'), testpath) #copy the image

        dup = article.amoeba_dup
        dup.images[0].id.wont_equal article.images[0].id
        dup.images[0].image_file_name.must_equal article.images[0].image_file_name
      end
    end

    describe "methods" do
      describe "#owned_by?(user)" do
        it "should return false when user is nil" do
          article.owned_by?(nil).must_equal nil
        end

        it "should return false when article doesn't belong to user" do
          db_article.owned_by?(FactoryGirl.create(:user)).must_equal false
        end

        it "should return true when article belongs to user" do
          db_article.owned_by?(db_article.seller).must_equal true
        end
      end

    end
  end


  describe "::FeesAndDonations" do
    before do
      article.seller = User.new

    end

    describe "#fee_percentage" do
      it "should return the fair percentage when article.fair" do
        article.fair = true
        article.send('fee_percentage').must_equal 0.03
      end

      it "should return the default percentage when !article.fair" do
        article.send('fee_percentage').must_equal 0.06
      end

      it "should return 0 percentage when article.seller.ngo" do
        article.seller.ngo = true
        article.send('fee_percentage').must_equal 0
      end

    end

    describe "#calculate_fees_and_donations" do

      it "should have 100 % friendly_percent for ngo" do
         ngo_article.friendly_percent.must_equal 100
       end

      #expand these unit tests!
      it "should return zeros on fee and fair cents with a friendly_percent of gt 100" do
        article.friendly_percent = 101
        article.calculate_fees_and_donations
        article.calculated_fair.must_equal 0
        article.calculated_fee.must_equal 0
      end

      it "should return zeros on fee and fair cents with a price of 0" do
        article.price = 0
        article.calculate_fees_and_donations
        article.calculated_fair.must_equal 0
        article.calculated_fee.must_equal 0
      end

      it "should return the max fee when calculated_fee gt max fee" do
        article.price = 9999
        article.fair = false
        article.calculate_fees_and_donations
        article.calculated_fee.must_equal Money.new(3000)
      end

      it "should always round the fair cents up" do
        article.price = 789.23
        article.fair = false
        article.calculate_fees_and_donations
        article.calculated_fair.must_equal Money.new(790)
      end

      it "should be no fees for ngo" do
        article.seller.ngo = true
        article.price = 999

        article.calculate_fees_and_donations
        article.calculated_fair.must_equal 0
        article.calculated_fee.must_equal 0
      end

    end
  end

  describe "::Attributes" do
    describe "validations" do
      it "should throw an error if no payment option is selected" do
        article.payment_cash = false
        article.save
        article.errors[:payment_details].must_equal [I18n.t("article.form.errors.invalid_payment_option")]
      end

      it "should throw an error if bank transfer is selected, but bank data is missing" do
        db_article.seller.stubs(:bank_account_exists?).returns(false)
        db_article.payment_bank_transfer = true
        db_article.save
        db_article.errors[:payment_bank_transfer].must_equal [I18n.t("article.form.errors.bank_details_missing")]
      end

      it "should throw an error if paypal is selected, but bank data is missing" do
        db_article.payment_paypal = true
        db_article.save
        db_article.errors[:payment_paypal].must_equal [I18n.t("article.form.errors.paypal_details_missing")]
      end

      it {subject.must validate_numericality_of(:transport_type1_number)}
      it {subject.must validate_numericality_of(:transport_type2_number)}
    end

    describe "methods" do

      describe "#transport_price" do
        let(:article) { FactoryGirl.create :article, :with_all_transports }

        it "should return an article's type1 transport price" do
          article.transport_price("type1").must_equal Money.new 2000
        end

        it "should return an article's type2 transport price" do
          article.transport_price("type2").must_equal Money.new 1000
        end

        it "should return an article's pickup transport price" do
          article.transport_price("pickup").must_equal Money.new 0
        end
      end

      describe "#transport_provider" do
        let(:article) { FactoryGirl.create :article, :with_all_transports }

        it "should return an article's type1 transport provider" do
          article.transport_provider("type1").must_equal 'DHL'
        end

        it "should return an article's type2 transport provider" do
          article.transport_provider("type2").must_equal 'Hermes'
        end

        it "should return an article's pickup transport provider" do
          article.transport_provider("pickup").must_equal nil
        end
      end

      describe "#total_price" do
        let(:article) { FactoryGirl.create :article, :with_all_transports }

        it "should return the correct price for cash_on_delivery payments" do
          expected = article.price + article.transport_type1_price + article.payment_cash_on_delivery_price
          article.total_price("type1", "cash_on_delivery", nil).must_equal expected
        end

        it "should return the correct price for non-cash_on_delivery payments" do
          expected = article.price + article.transport_type2_price
          article.total_price("type2", "cash", nil).must_equal expected
        end

        it "should return a multiplied price when a quantity is given" do
          article.transport_type2_number = 3
          expected = article.price * 3 + article.transport_type2_price
          article.total_price("type2", "cash", 3).must_equal expected
        end
      end

      describe "#price_without_vat" do
        it "should return the correct price" do
          article = FactoryGirl.create :article, price: 119, vat: 19, quantity: 2
          article.price_without_vat(2).must_equal Money.new 20000
        end
      end

      describe "#vat_price" do
        it "should return the correct price" do
          article = FactoryGirl.create :article, price: 119, vat: 19, quantity: 2
          article.vat_price(2).must_equal Money.new 3800
        end
      end

      describe "#selectable_transports" do
        it "should call the private selectable function" do
          article.expects(:selectable).with("transport")
          article.selectable_transports
        end
      end

      describe "#selectable_payments" do
        it "should call the private selectable function" do
          article.expects(:selectable).with("payment")
          article.selectable_payments
        end
      end

      describe "#selectable (private)" do
        it "should return an array with selected transport options, the default being first" do
          output = FactoryGirl.create(:article, :with_all_transports).send(:selectable, "transport")
          output[0].must_equal "pickup"
          output.must_include "type1"
          output.must_include "type2"
        end
      end

    end
  end

  describe "::Images" do
    describe "methods" do
      describe "#title_image_url" do
        it "should return the first image's URL when one exists" do
          db_article.title_image_url.must_match %r#/system/images/000/000/001/original/test2.png#
        end

        it "should return the missing-image-url when no image is set" do
          article = FactoryGirl.create :article, :without_image
          article.title_image_url.must_equal 'missing.png'
        end

         it "should return the first image's URL when one exists" do
          article.images = [FactoryGirl.build(:article_fixture_image),FactoryGirl.build(:article_fixture_image)]
          article.images.each do |image|
            image.is_title = true
            image.save
          end
          article.save
          article.errors[:images].must_equal [I18n.t("article.form.errors.only_one_title_image")]
        end

        it "should return the processing image while processing when requested a thumb" do
          title_image = FactoryGirl.build(:article_image, :processing)
          article.images = [title_image]
          article.title_image_url(:thumb).must_equal title_image.image.url(:thumb)
        end

        it "should return the original image while processing when requested a medium image" do
          title_image = FactoryGirl.build(:article_image, :processing)
          article.images = [title_image]
          article.title_image_url(:medium).must_equal title_image.original_image_url_while_processing
        end

      end

      describe "#add_image" do
        let(:article) { FactoryGirl.create :article,:without_image }
        before {
          @url = "http://www.test.com/test.png"
          article # We need to call it nowbecause else URI.stub :parse will Conflict with Fakeweb/Tire
        }

        it "should do nothing if the url is already present" do
          URI.stubs(:parse).returns( fixture_file_upload('/test.png') )
          assert_difference 'Image.count', 0 do
            article.add_image @url, true
          end
        end

        it "should delete a title image if another external url is given" do
          URI.stubs(:parse).returns( fixture_file_upload('/test.png') )
          @image = ArticleImage.create(:external_url => @url, :image => nil, :is_title => true)
          article.images << @image
          @image.update_attribute(:external_url, nil)
          @image.expects :delete
          article.add_image @url, true
        end

        it "should not delete a title image if the same external url is given" do
          URI.stubs(:parse).returns( fixture_file_upload('/test.png') )
          @image = ArticleImage.create(:external_url => @url, :image => nil, :is_title => true)
          article.images << @image
          @image.expects(:delete).never
          article.add_image @url, true
        end

        it "should add an error if a timeout happens" do
          Timeout.expects(:timeout).raises(Timeout::Error)
          article.add_image @url, true
        end

      end
    end
  end

  describe "::Categories" do
    describe "#size_validator" do
      it "should validate size of categories" do
        article_0cat = FactoryGirl.build :article
        article_0cat.categories = []
        article_1cat = FactoryGirl.build :article
        article_2cat = FactoryGirl.build :article, :with_child_category
        article_3cat = FactoryGirl.build :article, :with_3_categories

        article_0cat.valid?.must_equal false
        article_1cat.valid?.must_equal true
        article_2cat.valid?.must_equal true
        article_3cat.valid?.must_equal false
      end
    end
  end

  describe "::State" do
    describe "state machine hooks:" do
      describe "on activate" do
        it "should calculate the fees and donations" do
          article = FactoryGirl.create :preview_article
          article.calculated_fair_cents = 0
          article.calculated_fee_cents = 0
          article.save
          article.activate
          article.reload.calculated_fee.must_be :>, 0
          article.calculated_fair.must_be :>, 0
        end
      end
    end
  end

  describe "::Template" do
    before do
      @article = FactoryGirl.build :article, :with_private_user, template_name: 'Vorlage', state: :template
    end

    describe "#save_as_template?" do
      it "should return true when the save_as_template attribute is 1" do
        @article.save_as_template = "1"
        @article.save_as_template?.must_equal true
      end

      it "should return false when the save_as_template attribute is 0" do
        @article.save_as_template = "0"
        @article.save_as_template?.must_equal false
      end

    end
  end
end
