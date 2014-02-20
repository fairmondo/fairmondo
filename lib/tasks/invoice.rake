namespace :invoice do
  desc "find sold articles and add them to invoice"
  task :find => :environment do
    Transaction.where( "state = ? AND invoice_id = ? AND type IS NOT ?", "sold", nil, "MultipleFixedPriceTransaction" ).each do | transaction |
      Invoice.invoice_action_chain( transaction )
    end
  end
end
