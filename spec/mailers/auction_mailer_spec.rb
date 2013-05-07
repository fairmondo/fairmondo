require "spec_helper"

describe AuctionMailer do
  describe "report_auction" do
    let(:auction) { FactoryGirl.create(:auction) }
    let(:mail) { AuctionMailer.report_auction(auction,"text") }

    it "renders the subject" do
      mail.subject.should have_content("Auction reported")
    end

    it "contains the auction id" do
      mail.subject.should eq("Auction reported with ID: " + auction.id.to_s)
    end
  end

  describe "category_proposal" do
    it "should call the mail function" do
      a = AuctionMailer.send("new")
      a.should_receive(:mail).with(to: 'kundenservice@fairnopoly.de', subject: "Category proposal: foobar" ).and_return true
      a.category_proposal("foobar")
    end
  end
end
