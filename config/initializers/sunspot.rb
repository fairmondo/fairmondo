require "sunspot/queue/sidekiq"
backend = Sunspot::Queue::Sidekiq::Backend.new

# Find it out yourself why the sunspot queue is not working properly in specs
# If we dont do the unless all search related specs will randomly fail
Sunspot.session = Sunspot::Queue::SessionProxy.new(Sunspot.session, backend) unless Rails.env.test?

