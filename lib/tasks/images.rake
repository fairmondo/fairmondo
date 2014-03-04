require_dependency File.join(Rails.root,"app","models", "image.rb")
    # Why the fuck II ?  Doesn't work without this on staging/production'

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

  task :refresh_thumbs => :environment do
    count = Image.all.count
    Image.all.each_with_index do |image,index|
      begin
        image.image.reprocess! :thumb
        puts index.to_s + " / #{count.to_s}  - ID: #{image.id} - OK"
      rescue => e
        puts index.to_s + " / #{count.to_s}  - ID: #{image.id} - Exception: #{ e } (#{ e.class })"
      end
    end
  end


  # Source: https://gist.github.com/jlecour/1276437
  desc "Destroy paperclip attachment files that are not attached to any record"
  task :clean_orphan_files => :environment do

    @last_path = nil
    @dry_run = %w(true 1).include? ENV['DRY_RUN']
    @styles = ["original","medium","thumb","profile"]
    @root_dir = Pathname.new(Rails.root + 'public/system/images')

    Signal.trap('USR1') do
      puts "#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} #{@last_path}"
    end

    def delete_dir_if_empty(dir)
      if dir.children.none? { |e| (e.file? && e.extname != '') || e.directory? }
        if @dry_run
          puts "delete #{dir}"
        else
          dir.rmtree
        end
      end
    end


    def verify_directory(start_dir, model)
      @last_path = start_dir.to_s
      if start_dir.children.any? {|e| @styles.include? e.basename.to_s}
        PaperclipOrphanFileCleaner.delay.move_dir_if_orphan(start_dir, model)
      else
        start_dir.children.sort.each do |entry|
          full_path = (start_dir + entry)
          if full_path.directory?
            verify_directory(full_path, model)
          end
        end
        delete_dir_if_empty(start_dir)
      end
    end


    verify_directory(@root_dir, Image)
  end


end
