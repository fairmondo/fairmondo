#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module MassUpload::State
  extend ActiveSupport::Concern

  included do
    state_machine initial: :pending do
      event :start do
        transition pending: :processing
      end

      event :error do
        transition processing: :failed
        transition failed: :failed # maybe another worker calls it
      end

      event :finish do
        transition processing: :finished, if: :can_finish?
        transition finished: :finished
      end

      event :mass_activate do
        transition finished: :activated
        transition activated: :activated
      end

      after_transition to: :finished do |mass_upload, _transition|
        ArticleMailer.delay.mass_upload_finished_message(mass_upload.id)
      end

      after_transition processing: :failed do |mass_upload, transition|
        mass_upload.failure_reason = transition.args.first
        mass_upload.save
        ArticleMailer.delay.mass_upload_failed_message(mass_upload.id)
      end

      after_transition to: :activated do |mass_upload, _transition|
        mass_upload.articles_for_mass_activation.update_all(state: 'active')
        Indexer.delay_for(3.seconds).index_mass_upload mass_upload.id
        ArticleMailer.delay.mass_upload_activation_message(mass_upload.id)
      end
    end
  end
end
