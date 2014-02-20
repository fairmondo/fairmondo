class FastbillUpdateUserWorker
  include Sidekiq::Worker

  sidekiq_options queue: :fastbill,
                  retry: 20,
                  backtrace: true,
                  failures: true

  def perform user_id
    user = User.find(user_id)
    FastbillAPI.update_profile( user )
  end
end
