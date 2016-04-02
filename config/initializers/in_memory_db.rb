# Taken from https://gist.github.com/nmeylan/60aa53566d87d39ee6b0

def in_memory_database?
  Rails.env == 'test' and
    ActiveRecord::Base.connection.adapter_name.downcase.include?('sqlite') and
    Rails.configuration.database_configuration['test']['database'] == ':memory:'
end

if in_memory_database?
  require 'active_record/migration'
  ActiveRecord::Migration.verbose = false
  puts 'creating sqlite in memory database'
  load "#{Rails.root}/db/schema.rb"
end
