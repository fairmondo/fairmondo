namespace :mass_upload do
  desc 'Create a mass_upload from local CSV file'
  task :from_local_csv, [:filename, :user_id] => :environment do |task,args|

    def create_mass_upload(filename, user_id)
      mass_upload = MassUpload.new
      mass_upload.user = User.find(user_id)
      mass_upload.file_file_name = File.basename(filename)    # string gets downcased
      mass_upload.file_content_type = 'text/csv'
      mass_upload.save

      return mass_upload
    end

    mass_upload = create_mass_upload(args.filename, args.user_id)
    id = "%09d" % mass_upload.id
    destination = Rails.root.join('public', 'system', 'mass_uploads', 'files',
                    id[0,3], id[3,3], id[6,3], "original", mass_upload.file_file_name.downcase)

    FileUtils.mkdir_p(File.dirname(destination))
    FileUtils.copy_file(args.filename, destination)
    ProcessMassUploadWorker.perform_async mass_upload.id

  end
end

