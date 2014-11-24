class OldArticleDeletionWorker
  include Sidekiq::Worker
  # include Sidetiq::Schedulable

  # recurrence { weekly.day_of_week(1).hour_of_day(3) }

  sidekiq_options queue: :cleanup,
                  retry: 10,
                  backtrace: true

  def perform article_ids
    ref_ids = BusinessTransaction.pluck(:article_id)
    Article.where.not(id: ref_ids).where(state: :closed).where("updated_at <= ?", 1.month.ago).select(:id).find_in_batches(batch_size: 100) do |group|
      OldArticleDeletionWorker.delay(queue: :cleanup).do_delete(group.pluck(:id))
    end
  end

  def self.do_delete ids
    Article.where(id: ids).delete_all
  end
end
