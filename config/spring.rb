# Taken from https://gist.github.com/nmeylan/60aa53566d87d39ee6b0

if defined?(Spring)
  Spring.after_fork do
    load "#{Rails.root}/config/initializers/in_memory_db.rb"
  end
end
