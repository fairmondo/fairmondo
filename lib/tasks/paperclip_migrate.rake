namespace 'paperclip' do

  desc "migrate to gcs"
  task :migrate => :environment do
    # Initialize
    access_key = Rails.application.secrets.google_storage_access_key_id
    secret_key = Rails.application.secrets.google_storage_secret_access_key
    storage = Fog::Storage::Google.new google_storage_access_key_id: access_key,
                                       google_storage_secret_access_key: secret_key

    bucket_name = Rails.application.secrets.google_bucket_name
    bucket = storage.directories.get(bucket_name)

    # s3_options = YAML.load_file(File.join(Rails.root, 'config/aws.yml')).symbolize_keys

    # bucket_name = s3_options[Rails.env.to_sym]["bucket"]

    # AWS.config(
    #   :access_key_id => s3_options[Rails.env.to_sym]["access_key_id"],
    #   :secret_access_key => s3_options[Rails.env.to_sym]["secret_access_key"]
    # )

    # s3 = AWS::S3.new
    # bucket = s3.buckets[bucket_name]



    classes = []
    classes = ENV['Class'].split(",") if ENV['Class']

    classes.each do |class_info|
      begin
        class_name = class_info.split(":")[0]
        attachment_name = class_info.split(":")[1].downcase

        class_def = class_name.constantize

        puts "Migrating #{class_name}:#{attachment_name}..."
        if class_def.all.empty?
          puts "#{class_name} is empty"
          next
        end

        styles = class_def.first.send(attachment_name).styles.map{|style| style[0]}

        class_def.find_each do |instance|
          if not instance.send(attachment_name).exists? or instance.send(attachment_name).url.include? "google"
            next
          end

          styles.each do |style|
            attach = instance.send(attachment_name).path(style.to_sym)
            filename = attach.split("/").last
            path = "#{class_name.underscore.pluralize}/#{attachment_name.pluralize}/#{instance.id}/#{style}/#{filename}"
            file = File.open(attach)
            puts "Storing #{style} #{filename} in GCS..."
            attachment = storage.put_object(bucket_name, path, file,
              'x-goog-acl' => 'public-read')
          end
        end
      # rescue AWS::S3::Errors::NoSuchBucket => e
      #   puts "Creating the non-existing bucket: #{bucket_name}"
      #   storage.put_bucket(bucket_name)
      #   retry
      rescue Exception => e
        puts "Ignoring #{class_name}"
        puts e
      end
      puts ""
    end
  end
end
