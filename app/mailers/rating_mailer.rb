class RatingMailer < ActionMailer::Base
  default from: EMAIL_ADDRESSES['default']

  def bad_seller_notification user
    mail(to: EMAIL_ADDRESSES['default'], subject: "User #{user.id} wurde als schlechter Verkäufer eingestuft. Bitte überprüfen.")
  end
end
