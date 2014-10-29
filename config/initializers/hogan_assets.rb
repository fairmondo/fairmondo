HoganAssets::Config.configure do |config|
  config.template_namespace = 'Template'
  config.path_prefix = 'templates'
  config.template_extensions = %w(mustache hamstache slimstache)
  config.haml_options[:ugly] = true
end
