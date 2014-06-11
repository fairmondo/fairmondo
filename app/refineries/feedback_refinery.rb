class FeedbackRefinery < ApplicationRefinery

  def create
    [
      :from, :subject, :text, :variety, :article_id, :feedback_subject,
      :help_subject, :forename, :lastname, :organisation, :phone, :recaptcha,
      { image_attributes: ImageRefinery.new(Image.new, user).default }
    ]
  end
end
