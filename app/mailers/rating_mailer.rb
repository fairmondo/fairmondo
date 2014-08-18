class RatingMailer < ActionMailer::Base
  default from: $email_addresses['default']

  def bad_seller_notification user
    mail(to: "test@test.de", from: "test2@test.de", subject: "User #{user.id} hat neuen Status BAD_SELLER")
  end
end