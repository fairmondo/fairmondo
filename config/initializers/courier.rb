begin
  courier = YAML.load(File.read('/var/www/fairnopoly/shared/config/courier.yml'))
  $courier = courier['courier']

rescue
  puts 'courier.yml not found'
end
