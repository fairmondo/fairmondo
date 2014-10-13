class QueueDisablerMetaWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily.hour_of_day(8) }

  sidekiq_options queue: :default,
                  retry: 5,
                  backtrace: true

  def perform
    QueueEnablerMetaWorker::NIGHT_WORKER.each do |queue_name|
      Sidekiq::Queue.new(queue_name).pause!
    end
  end
end
