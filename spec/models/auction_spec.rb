require 'spec_helper'

describe Auction do

  let(:auction) { FactoryGirl::create(:auction) }
  subject { auction }

  it {should have_many :images}

  it {should belong_to :seller}
  it {should have_many :categories}

  it "should return the title image" do
    image = FactoryGirl.create(:image, :auction => auction)
    auction.title_image
  end

  describe "with_user_id scope" do
    before do
      @auction_with_id = FactoryGirl.create(:auction)
      @auction_without_id = FactoryGirl.create(:auction).user_id = nil
    end

    it "should return all auctions with a user_id when called with 'true'" do
      results = Auction.with_user_id(true)
      results.should include(@auction_with_id)
      results.should_not include(@auction_without_id)
    end

    it "should return all auctions with a specific user_id when called with an integer" do
      auction_with_correct_id = FactoryGirl.create(:auction)
      results = Auction.with_user_id(auction_with_correct_id.user_id)
      results.should include(auction_with_correct_id)
      results.should_not include(@auction_with_id)
      results.should_not include(@auction_without_id)
    end
  end

  context "Auction::Initial" do
    it "should rescue MissingAttributeErrors" do
      auction.stub(:new_record?) { raise ActiveModel::MissingAttributeError }
      auction.initialize_values.should_not raise_error(ActiveModel::MissingAttributeError)
    end
  end

  context "Auction::FeesAndDonations" do
    context "friendly_percent_calculated" do
      it "should call friendly_percent_result" do
        auction.should_receive :friendly_percent_result
        auction.friendly_percent_calculated
      end
    end
    context "fee_percentage" do
      it "should return the fair percentage when auction.fair" do
        auction.fair = true
        auction.send('fee_percentage').should == 0.03
      end

      it "should return the default percentage when !auction.fair" do
        auction.send('fee_percentage').should == 0.06
      end
    end
  end

  context "Auction::Attributes" do
    it "should throw an error if default_transport_selected isn't able to call the transport function" do
      auction.default_transport.should be_true
      auction.stub(:send).and_return(false)
      expect { auction.default_transport_selected }.to raise_error
    end
  end

  context "Auction::Commendation" do
    describe "with_commendation scope" do
      it "should be unscoped without commendations" do
        Auction.with_commendation.should == Auction.scoped
      end
      it "should return the correct scope with given commendations" do
        auction_without_commendations = FactoryGirl.create(:auction)
        auction_fair = FactoryGirl.create(:auction, fair: true, fair_kind: :fair_trust)
        auction_ecologic = FactoryGirl.create(:auction, ecologic: true, ecologic_kind: :ecologic_seal, ecologic_seal: :bio_siegel)
        auction_fair_ecologic = FactoryGirl.create(:auction, fair: true, fair_kind: :fair_trust, ecologic: true, ecologic_kind: :ecologic_seal, ecologic_seal: :bio_siegel)

        results = Auction.with_commendation :fair, :ecologic
        results.should include(auction_fair_ecologic, auction_fair, auction_ecologic)
        results.should_not include(auction_without_commendations)
      end
    end
  end

  context "Auction::Categories" do
    describe "with_exact_category_id scope" do
      it "should be unscoped without category_id" do
        Auction.with_exact_category_id.should == Auction.scoped
      end
      it "should return all auctions of a given category" do
        pending
        auction1_cat1 = FactoryGirl.create :auction, :category8
        auction2_cat1 = FactoryGirl.create :auction, :category8
        auction1_cat2 = FactoryGirl.create :auction, :category9

        results = Auction.with_exact_category_id 8
        results.should include auction1_cat1, auction2_cat1
        results.should_not include auction1_cat2
      end
    end
  end
end