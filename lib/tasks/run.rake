namespace :run do
  desc 'Update the current repository branch'
  task :update do
    puts 'Pulling from branch ...'
    system 'git pull'

    puts 'Getting new gems...'
    system 'bundle'

    puts 'Updating database...'
    system 'rake run:migrations'
    puts "\n\nBranch successfully updated.\n\n"
  end

  desc 'Update database'
  task :migrations do
    system 'rake db:migrate'
    system 'rake db:test:prepare'
  end
end

task update: 'run:update'
