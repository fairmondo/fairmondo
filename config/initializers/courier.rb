begin
  courier = YAML.load(File.read(File.expand_path(File.join(Rails.root, 'config', 'courier.yml')))
                      )
  $courier = courier['courier']

rescue
  puts 'courier.yml not found'
end
