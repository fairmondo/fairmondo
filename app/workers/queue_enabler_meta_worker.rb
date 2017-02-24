#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class QueueEnablerMetaWorker
  include Sidekiq::Worker

  sidekiq_options queue: :sidekiq_pro,
                  retry: 5,
                  backtrace: true

  NIGHT_WORKER = ['file_normalizer']

  def perform
    NIGHT_WORKER.each do |queue_name|
      Sidekiq::Queue.new(queue_name).unpause! if Rails.env.production?
    end
  end
end
