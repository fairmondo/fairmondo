#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module MassUploadConcerns
  module State
    extend ActiveSupport::Concern

    included do
      after_initialize :initialize_state_machines
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
          ArticleMailer.mass_upload_finished_message(mass_upload.id).deliver_later
        end

        after_transition processing: :failed do |mass_upload, transition|
          mass_upload.failure_reason = transition.args.first
          mass_upload.save
          ArticleMailer.mass_upload_failed_message(mass_upload.id).deliver_later
        end

        after_transition to: :activated do |mass_upload, _transition|
          mass_upload.articles_for_mass_activation.update_all(state: 'active')
          Indexer.index_mass_upload mass_upload.id
          ArticleMailer.mass_upload_activation_message(mass_upload.id).deliver_later
        end
      end
    end
  end
end
