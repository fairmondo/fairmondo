# https://gist.github.com/jarosan/3124884
# Run with: rake elasticsearch:reindex

namespace :elasticsearch do
  desc 're-index elasticsearch'
  task reindex: :environment do
    puts 'reindexing ...'

    ArticlesIndex.reset! Time.now.to_i

    puts 'done.'
  end
end
