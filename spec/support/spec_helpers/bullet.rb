# Check for n+1 queries and other slow stuff
RSpec.configure do |config|
  $bullet_log = "#{Rails.root.to_s}/log/bullet.log"

  config.before :suite do
    # Empty out the bullet log
    File.open($bullet_log, 'w') {|f| f.truncate(0) }
  end

  config.after :suite do
    unless $skip_audits
      puts "\n\n[Bullet] Checking for performance drains:\n".underline
      bullet_warnings = File.open($bullet_log, "rb").read

      if bullet_warnings.empty?
        puts "No issues found. Very good.".green
      else
        puts bullet_warnings.yellow
        puts "Please deal with these issues before pushing.".red.underline
      end
    end
  end
end
