class FeedbackRefinery < ApplicationRefinery

  def new
    [ :variety ]
  end

  def create
    use_root
    [
      :from, :subject, :text, :variety, :article_id, :feedback_subject,
      :help_subject, :forename, :lastname, :organisation, :phone, :recaptcha,
      { image_attributes: ImageRefinery.new(Image.new, user).default }
    ]
  end
end
