#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class FeedbacksController < ApplicationController
  include ImageParams

  REQUIRED_PARAMS = [
    :from, :subject, :text, :variety, :article_id, :feedback_subject,
    :help_subject, :forename, :lastname, :organisation, :phone, :recaptcha,
    { image_attributes: IMAGE_PARAMS }
  ].freeze

  respond_to :html
  skip_before_action :authenticate_user!

  def create
    handle_recaptcha
    @feedback = Feedback.new(params.require(:feedback).permit(*REQUIRED_PARAMS))
    authorize @feedback
    @feedback.put_user_id current_user
    @feedback.source_page = JSON.pretty_generate(session[:previous_urls] || [])
    @feedback.user_agent = request.env['HTTP_USER_AGENT']
    flash[:notice] = I18n.t('article.actions.reported') if @feedback.save
    respond_with @feedback, location: -> { redirect_path }
  end

  def new
    @feedback = Feedback.new
    @variety = params[:variety] || 'send_feedback'
    # session[:source_page] = request.env["HTTP_REFERER"] # probably not needed because of session[:previous_urls]
    authorize @feedback
    respond_with @feedback
  end

  private

  def redirect_path
    if @feedback.variety == 'report_article'
      article_path Article.find @feedback.article_id
    else
      root_path
    end
  end

  def handle_recaptcha
    params[:feedback]['recaptcha'] = '0'
    if verify_recaptcha
      params[:feedback]['recaptcha'] = '1'
    else
      flash.delete :recaptcha_error
    end
  end
end
