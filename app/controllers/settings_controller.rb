class SettingsController < ApplicationController

  def update #allows get!
    authorize Settings.new

    value = Sanitize.clean(permitted_params[:value])
    case permitted_params[:var]
    when 'pioneer_id'
      Settings.pioneer_id = value
    when 'pioneer2_id'
      Settings.pioneer2_id = value
    when 'dream_team_article_id'
      Settings.dream_team_article_id = value
    when 'dream_team_article2_id'
      Settings.dream_team_article2_id = value
    end # add other settings as necessarcy

    redirect_to :back
  end

  private
    def permitted_params
      params.permit *Settings.setting_attrs
    end
end
