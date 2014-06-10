# Source: https://gist.github.com/jlecour/1276437
class PaperclipOrphanFileCleaner
  def self.reverse_id_partition(path)
    parts = path.to_s.split('/')[-3..-1]
    if parts.all? { |e| e =~ /^\d{3}$/}
      parts.join.to_i
    end
  end

  def self.is_orphan?(model, id)
    !model.exists?(id)
  end

  def self.move_to_deleted_directory(old_path)
    parts = old_path.to_s.split('/')
    if parts.include?('images')
      new_dir = old_path.to_s.gsub(/\bimages\b/,'images_deleted')
      new_path = Pathname.new(new_dir)
      new_path.mkpath

      old_path.rename new_path
    end
  end

  def self.move_dir_if_orphan(dir, model)
    id = reverse_id_partition(dir)
    if id && is_orphan?(model, id)
      if @dry_run
        puts "#{model}##{id} : orphan"
      else
        move_to_deleted_directory(dir)
      end
    end
  end
end