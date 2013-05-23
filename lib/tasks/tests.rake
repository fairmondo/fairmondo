namespace :test do
  desc 'Run a Brakeman security audit'
  task :brakeman do
    system 'brakeman -z --summary'
  end
end