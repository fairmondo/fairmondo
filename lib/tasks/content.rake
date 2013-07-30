namespace :content do
  desc "Import content"
  task :import_csv, [:csv_location] => :environment do |t, args|
    CSV.foreach(args.csv_location, headers: true) do |row|
      hash_row = row.to_hash
      content_new = Content.find_or_create_by_key(hash_row["Key"])
      content_new.update_attributes(body: hash_row["Body"])
      content_new.save
    end
  end
end




cap staging content:import /Users/basti/Downloads/content_2013-07-26_14h11m25.csv