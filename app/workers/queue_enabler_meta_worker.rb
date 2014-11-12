class QueueEnablerMetaWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily.hour_of_day(0) }

  sidekiq_options queue: :default,
                  retry: 5,
                  backtrace: true

  NIGHT_WORKER = ['file_normalizer', 'paperclip_background']

  def perform
    NIGHT_WORKER.each do |queue_name|
      Sidekiq::Queue.new(queue_name).unpause!
    end
  end
end
