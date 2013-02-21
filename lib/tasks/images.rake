namespace :images do
  desc "Clean images with no auction"
  task :clean => :environment do
     Image.destroy_all(:auction_id => nil)
  end

end
