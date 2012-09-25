namespace :db do
  desc "Clear all Auctions"
  task :reset_all_auctions => :environment do
    Auction.destroy_all
    puts "Finished."
  end
end