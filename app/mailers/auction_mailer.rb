class AuctionMailer < ActionMailer::Base
  default from: "kundenservice@fairnopoly.de"

  def report_auction(auction,text)
    @text = text
    @auction = auction
    mail(:to => "melden@fairnopoly.de", :subject => "Auction reported with ID: " + auction.id.to_s)
  end

  def category_proposal(category_proposal)
    mail(:to => "kundenservice@fairnopoly.de", :subject => "Category proposal: " + category_proposal)
  end

end