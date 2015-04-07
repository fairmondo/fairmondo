class FastbillUpdateUserWorker
  include Sidekiq::Worker

  sidekiq_options queue: :fastbill,
                  retry: 20,
                  backtrace: true

  def perform user_id
    user = User.find(user_id)
    api = FastbillAPI.new
    api.update_profile(user)
  end
end
