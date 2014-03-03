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

    Signal.trap('USR1') do
      puts "#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} #{@last_path}"
    end

    def reverse_id_partition(path)
      parts = path.to_s.split('/')[-3..-1]
      if parts.all? { |e| e =~ /^\d{3}$/}
        parts.join.to_i
      end
    end

    def is_orphan?(model, id)
      !model.exists?(id)
    end

    def move_to_deleted_directory(old_path)
      parts = old_path.to_s.split('/')
      if parts.include?('images')
        new_dir = old_path.to_s.gsub(/\bimages\b/,'images_deleted')
        new_path = Pathname.new(new_dir)
        new_path.mkpath

        old_path.rename new_path
      end
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

    def move_dir_if_orphan(dir, model)
      id = reverse_id_partition(dir)
      if id && is_orphan?(model, id)
        if @dry_run
          puts "#{model}##{id} : orphan"
        else
          move_to_deleted_directory(dir)
        end
      end
    end

    def verify_directory(start_dir, model)
      @last_path = start_dir.to_s
      if start_dir.children.any? {|e| @styles.include? e.basename.to_s}
        move_dir_if_orphan(start_dir, model)
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

    start_dir = Pathname.new(Rails.root + 'public/system/images')
    verify_directory(start_dir, Image)
  end


end
