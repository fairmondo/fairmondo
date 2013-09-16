class SettingsController < ApplicationController

  def update #allows get!
    authorize Settings.new

    value = Sanitize.clean(permitted_params[:value])
    case permitted_params[:var]
    when 'featured_article_id'
      Settings.featured_article_id = value
    end # add other settings as necessarcy

    redirect_to :back
  end

  private
    def permitted_params
      params.permit *Settings.setting_attrs
    end
end
