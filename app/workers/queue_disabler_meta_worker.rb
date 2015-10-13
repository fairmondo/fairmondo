#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class QueueDisablerMetaWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily.hour_of_day(8) }

  sidekiq_options queue: :sidekiq_pro,
                  retry: 5,
                  backtrace: true

  def perform
    QueueEnablerMetaWorker::NIGHT_WORKER.each do |queue_name|
      Sidekiq::Queue.new(queue_name).pause! if Rails.env.production?
    end
  end
end
