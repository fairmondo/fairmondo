system('clear')
puts "Welcome to the Fairnopoly setup."
puts "\n\n* This script requires you to already have the rails gem installed."
puts "* Make sure you are in the fairnopoly root directory."
puts "* Please do not run this script more than once."
puts "\nPress enter to continue (or type \"abort\" to exit)."

unless gets.chomp === "abort"
	puts "\n\nOK. Here we go:"

  puts "Installing gems..."
  %x( bundle install )

  puts "Copying development environment..."
  %x( cp config/environments/development.example.rb config/environments/development.rb )

  puts "Copying secret token..."
  %x( cp config/initializers/secret_token.example config/initializers/secret_token.rb )

  puts "Creating Fairnopoly database..."
  %x( rake db:create )

  puts "Migrating database..."
  %x( rake db:migrate )

  puts "Seeding database..."
  %x( rake db:seed )

  puts "Preparing test database..."
  %x( rake db:test:prepare )

  puts "\n\n\nDo you want to set up reCAPTCHA support? Without it you won't be able to access certain pages like the user registration. But you will need to set up a Google account."
  puts "Press enter to continue (or type \"abort\" to skip the reCAPTCHA setup)."
  unless gets.chomp === "abort"
    puts "\n\nOK. Please go to https://www.google.com/recaptcha/admin/list and \"Add a New Site\". Ensure that you enable all domains."
    puts "After clicking on \"Create Key\" you should get a public and a private key."
    puts "\nPlease enter the public key below or type in \"abort\" if you changed your mind."
    public_key = gets.chomp

    unless public_key === "abort"
      puts "Now please enter your private key:"
      private_key = gets.chomp

      puts "Creating api.yml..."
      %x( printf "recaptcha:\n public: #{public_key}\n private: #{private_key}\n" | cat > config/api.yml )
    end
  end

  system('clear')
  puts "\nAlright! The project should be set up now."
  puts "\n\nTo see if it works simply run 'rails server' and then open a browser at http://localhost:3000"
end