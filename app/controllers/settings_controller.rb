class SettingsController < ApplicationController

  def update #allows get!
    authorize Settings.new

    value = Sanitize.clean(params[:value])
    case params[:var]
    when 'featured_article_id'
      Settings.featured_article_id = value
    end # add other settings as necessarcy

    redirect_to :back
  end

  private
    def permitted_params
      params.permit *Setting.setting_params
    end
end
