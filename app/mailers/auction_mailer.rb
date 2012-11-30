class AuctionMailer < ActionMailer::Base
  default from: "info@fairnopoly.de"
  def report_auction(auction)
    mail(:to => "report@fairnopoly.de", :subject => "Auction reported with ID: " + auction.id.to_s)
  end
end