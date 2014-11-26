rails_root = ENV['RAILS_ROOT'] || File.expand_path(".")
rails_env = ENV['RAILS_ENV'] || 'staging'

# Eye self-configuration section
Eye.config do
  logger "#{rails_root}/log/eye.log"
end

Eye.application 'fairmondo' do
  working_dir = rails_root

  group 'sidekiq' do
    1.times do |i|
      process "sidekiq#{i}" do

        _pidfile = "#{rails_root}/tmp/pids/sidekiq#{i}.pid"
        pid_file _pidfile

        start_command "sidekiq -e #{rails_env} -P #{_pidfile} -d -L #{rails_root}/log/sidekiq.log -C #{rails_root}/config/sidekiq.yml -i #{i}"
        stop_command "sidekiqctl stop #{_pidfile}"

        start_grace = 30.seconds
        stop_grace = 90.seconds
        restart_grace = 120.seconds

        #check :cpu, every: 10.seconds, below: 5, times: 3
        check :memory, every: 10.seconds, below: 500.megabytes, :times => [2,3]
        check :runtime, every: 10.minutes, below: 12.hours

      end
    end
  end
end
