begin
  require 'warbler'
  Warbler::Task.new
  task :war => ["assets:precompile"]
rescue LoadError => e
  puts "Failed to load Warbler. Make sure it's installed."
end