begin
  $courier = YAML.load_file(File.join(Rails.root, 'config', 'courier.yml'))

rescue
  puts 'courier.yml not found'
end
