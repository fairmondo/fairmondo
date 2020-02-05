#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

### SimpleCOV ###

require 'simplecov'
require 'coveralls'
require 'simplecov-json'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter,
  SimpleCov::Formatter::JSONFormatter
]

SimpleCov.start 'rails' do
  add_filter "lib/tasks/*"
  add_filter "app/models/statistic.rb" #only backend
  add_filter "app/helpers/statistic_helper.rb" #only backend
  add_filter "lib/autoload/sidekiq_redis_connection_wrapper.rb" #util-class
  add_filter "lib/autoload/paperclip_orphan_file_cleaner.rb" #part of rake task
  #reference implementations
  add_filter "lib/autoload/paypal_ipn.rb"
  add_filter "lib/autoload/single_sign_on.rb"
  minimum_coverage 98
end
