class CourierMailer < ActionMailer::Base
  include MailerHelper
  before_filter :inline_logos

  default from: $email_addresses['default']
  layout 'email'

end
