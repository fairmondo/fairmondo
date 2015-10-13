#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

HoganAssets::Config.configure do |config|
  config.template_namespace = 'Template'
  config.path_prefix = 'templates'
  config.template_extensions = %w(mustache hamstache slimstache)
  config.haml_options[:ugly] = true
end
