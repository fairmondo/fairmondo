namespace :images do
  desc "Refresh Image styles"
  task :refresh => :environment do
    count = Image.all.count
    Image.all.each_with_index do |image,index|
      begin
        image.image.reprocess!
        puts index.to_s + " / #{count.to_s}  - ID: #{image.id} - OK"
      rescue => e
        puts index.to_s + " / #{count.to_s}  - ID: #{image.id} - Exception: #{ e } (#{ e.class })"
      end
    end
  end

end
