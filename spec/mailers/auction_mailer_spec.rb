require "spec_helper"

describe AuctionMailer do

  describe "report auction" do

    before :each do
      @auction = FactoryGirl.create(:auction)
      @mail = AuctionMailer.report_auction(@auction,"text")
    end

    it "renders the subject" do
      @mail.subject.should have_content("Auction reported")
    end

    it "contains the auction id" do
      @mail.subject.should eq ("Auction reported with ID: " + @auction.id.to_s)
    end

  end

end
