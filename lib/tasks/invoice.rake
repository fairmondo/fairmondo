namespace :invoice do
  desc "find sold articles and add them to invoice"
  task :find => :environment do
    BusinessTransaction.where( "state = ? AND invoice_id = ? AND type IS NOT ?", "sold", nil, "MultipleFixedPriceTransaction" ).each do | business_transaction |
      Invoice.invoice_action_chain( business_transaction )
    end
  end
end
