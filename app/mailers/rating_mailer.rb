class RatingMailer < ActionMailer::Base
  default from: $email_addresses['default']

  def bad_seller_notification user
    mail(to: $email_addresses['default'], subject: "User #{user.id} wurde als schlechter Verkäufer eingestuft. Bitte überprüfen.")
  end
end