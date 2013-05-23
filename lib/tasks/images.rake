namespace :images do
  desc "Clean images with no article"
  task :clean => :environment do
    Image.destroy_all(:article_id => nil)
  end

end
