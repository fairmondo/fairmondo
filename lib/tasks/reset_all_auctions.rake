namespace :db do
  desc "Clear all Articles"
  task :reset_all_articles => :environment do
    Article.destroy_all
    puts "Finished."
  end
end
