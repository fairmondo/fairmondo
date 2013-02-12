namespace :categories do
  desc "Rebuild categories nested set"
  task :rebuild => :environment do
    Category.rebuild!
  end
end