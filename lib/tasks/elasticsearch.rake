# https://gist.github.com/jarosan/3124884
# Run with: rake elasticsearch:reindex

namespace :elasticsearch do
  desc "re-index elasticsearch"
  task :reindex => :environment do

    klass = Article
    ENV['CLASS'] = klass.name
    ENV['INDEX'] = new_index = klass.tire.index.name << '_' << Time.now.strftime('%Y%m%d%H%M%S')

    Rake::Task["tire:import"].invoke

    puts '[IMPORT] about to swap index'
    if a = Tire::Alias.find(klass.tire.index.name)
      puts "[IMPORT] aliases found: #{Tire::Alias.find(klass.tire.index.name).indices.to_ary.join(',')}. deleting."
      old_indices = Tire::Alias.find(klass.tire.index.name).indices
      old_indices.each do |index|
        a.indices.delete index
      end

      a.indices.add new_index
      a.save

      old_indices.each do |index|
        puts "[IMPORT] deleting index: #{index}"
        i = Tire::Index.new(index)
        i.delete if i.exists?
      end
    else
      puts "[IMPORT] no aliases found. deleting index. creating new one and setting up alias."
      klass.tire.index.delete
      a = Tire::Alias.new
      a.name(klass.tire.index.name)
      a.index(new_index)
      a.save
    end

    puts "[IMPORT] done. Index: '#{new_index}' created."
  end
end