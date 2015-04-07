begin
  BELBOON_IDS = YAML.load(File.read(File.expand_path(File.join( Rails.root, 'config', 'belboon_trackable_users.yml'))))[:belboon][:users]
rescue
  puts 'belboon_trackable_users.yml not found'
  BELBOON_IDS = []
end
