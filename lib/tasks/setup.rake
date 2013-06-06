namespace :setup do
  desc 'Update the current repository branch'
  task :update do
    puts 'Pulling from branch ...'
    system 'git pull'

    puts 'Getting new gems...'
    system 'bundle'

    puts 'Updating database...'
    system 'rake db:migrate'
    system 'rake db:test:prepare'

    puts '\n\n\nBranch successfully updated.'
  end
end

task :setup => 'setup:update'
