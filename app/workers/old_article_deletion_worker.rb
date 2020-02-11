#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class OldArticleDeletionWorker
  include Sidekiq::Worker

  sidekiq_options queue: :cleanup,
                  retry: 10,
                  backtrace: true

  def perform
    ref_ids = BusinessTransaction.pluck(:article_id) # could get dangerous in the future with more sales
    Article.where.not(id: ref_ids).where(state: :closed).where('updated_at <= ?', 1.month.ago).select(:id).find_in_batches(batch_size: 100) do |group|
      Article.where(id: group.map(&:id)).delete_all
    end
  end
end
