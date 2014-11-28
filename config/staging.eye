dir = ENV['RBENV_DIR'] || ENV['PWD'] || File.expand_path(".")
rails_env = ENV['RAILS_ENV'] || 'staging'

# Eye self-configuration section
Eye.config do
  logger "#{dir}/log/eye.log"
end

Eye.application 'fairmondo' do
  working_dir dir

  group 'sidekiq' do
    1.times do |i|
      process "sidekiq#{i}" do

        _pidfile = "#{dir}/tmp/pids/sidekiq#{i}.pid"
        pid_file _pidfile
        stdall 'log/trash.log'
        daemonize true

        start_command "bundle exec sidekiq -e #{rails_env} -P #{_pidfile} -L #{dir}/log/sidekiq.log -C #{dir}/config/sidekiq.yml -i #{i}"
        stop_command "bundle exec sidekiqctl stop #{_pidfile}"

        start_grace 30.seconds
        stop_grace 90.seconds
        restart_grace 120.seconds

        #check :cpu, every: 10.seconds, below: 5, times: 3
        check :memory, every: 10.seconds, below: 500.megabytes, times: [2,3]
        check :runtime, every: 10.minutes, below: 12.hours

      end
    end
  end
end
