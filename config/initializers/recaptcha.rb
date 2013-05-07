begin

  api = YAML.load(File.read(File.expand_path(File.join( Rails.root, 'config', 'api.yml'))))

  Recaptcha.configure do |config|

    config.public_key  = api['recaptcha']['public']
    config.private_key = api['recaptcha']['private']

  end
rescue
  puts 'api.yml not found'
end