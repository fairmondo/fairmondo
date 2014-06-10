#
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Farinopoly.
#
# Farinopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Farinopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Farinopoly.  If not, see <http://www.gnu.org/licenses/>.
#
class FeedbacksController < InheritedResources::Base
  respond_to :html
  actions :create, :new
  skip_before_filter :authenticate_user!

  def create
    handle_recaptcha
    authorize build_resource
    resource.set_user_id current_user
    resource.source_page = session[:source_page]
    resource.user_agent = request.env["HTTP_USER_AGENT"]
    create! do |success,failure|
      success.html { redirect_to redirect_path, notice: (I18n.t 'article.actions.reported')  }
    end
  end

  def new
    @variety = params.for(build_resource).refine[:variety] || "send_feedback"
    session[:source_page] = request.env["HTTP_REFERER"]
    authorize build_resource
    new!
  end

  private

    def redirect_path
      if @feedback.variety == "report_article"
        article_path(Article.find(@feedback.article_id))
      else
        root_path
      end
    end

    def handle_recaptcha
      params[:feedback]["recaptcha"] = '0'
      if verify_recaptcha
        params[:feedback]["recaptcha"] = '1'
      else
        flash.delete :recaptcha_error
      end
    end
end
