#
#
# == License:
# Fairmondo - Fairmondo is an open-source online marketplace.
# Copyright (C) 2013 Fairmondo eG
#
# This file is part of Fairmondo.
#
# Fairmondo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairmondo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairmondo.  If not, see <http://www.gnu.org/licenses/>.
#
unless ` pwd ` =~ /fairmondo\n$/
  puts 'You need to run this setup script from the Fairmondo root directory.'
  exit 1
end

system('clear')
puts 'Welcome to the Fairmondo setup.'
puts "\n\n* This script requires you to already have the rails gem installed."
puts '* Make sure you are in the fairmondo root directory.'
puts '* Please do not run this script more than once.'
puts "\nPress enter to continue (or type \"abort\" to exit)."

unless gets.chomp == 'abort'
  puts "\n\nOK. Here we go:"

  puts 'First we have to make sure you have postgres installed correctly...'
  puts '(This may take a while.)'
  puts ` gem install pg `
  unless $?.exitstatus == 0
    puts "\n\nIt doesn't look like that worked."
    puts "\nPlease make sure you have postgres installed."
    puts "\nOn linux try:"
    puts 'sudo apt-get install libpq-dev'
    puts 'On mac try installing homebrew and do:'
    puts 'brew install postgres'
    puts "On windows try getting a different OS. (Seriously though, this script doesn't support windows. Do steps outlined in the README manually.)"
    puts "\nAfter you did that, ensure 'gem install pg' runs without errors and run this script again with 'ruby setup.rb'."
    exit
  end

  puts 'Installing gems...'
  puts '(This may take a while.)'
  puts ` bundle install `
  unless $?.exitstatus == 0
    puts "\n\n---------------------------------"
    puts "\n\nIt doesn't look like that worked."
    puts "\nThis script will abort now. Please make sure running 'bundle install' succeeds."
    puts "Then run this script again with 'ruby setup.rb'"
    exit
  end

  puts 'Copying development environment...'
  ` cp config/environments/development.example.rb config/environments/development.rb `

  puts 'Copying secret token...'
  ` cp config/initializers/secret_token.example config/initializers/secret_token.rb `

  puts 'Copying email_addresses.yml...'
  ` cp config/email_addresses.yml.example config/email_addresses.yml `

  puts 'Creating Fairmondo database...'
  ` rake db:create `

  puts 'Migrating database...'
  ` rake db:migrate `

  puts 'Seeding database...'
  ` rake db:seed `

  puts 'Preparing test database...'
  ` rake db:test:prepare `

  puts 'Running local sidekiq...'
  ` bundle exec sidekiq --daemon --logfile log/sidekiq.log `

  puts "\n\n\nDo you want to set up reCAPTCHA support? Without it you won't be able to access certain pages like the user registration. But you will need to set up a Google account."
  puts "Press enter to continue (or type \"abort\" to skip the reCAPTCHA setup)."
  unless gets.chomp == 'abort'
    puts "\n\nOK. Please go to https://www.google.com/recaptcha/admin/list and \"Add a New Site\". Ensure that you enable all domains."
    puts "After clicking on \"Create Key\" you should get a public and a private key."
    puts "\nPlease enter the public key below or type in \"abort\" if you changed your mind."
    public_key = gets.chomp

    unless public_key == 'abort'
      puts 'Now please enter your private key:'
      private_key = gets.chomp

      puts 'Creating api.yml...'
      ` printf "recaptcha:\n public: #{public_key}\n private: #{private_key}\n" | cat > config/api.yml `
    end
  end

  system('clear')
  puts "\nAlright! The project should be set up now."
  puts "\n\nTo see if it works simply run 'rails server' and then open a browser at http://localhost:3000"
end
