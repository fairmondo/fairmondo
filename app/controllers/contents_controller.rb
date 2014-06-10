#
# Farinopoly - Fairnopoly is an open-source online marketplace.
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
class ContentsController < InheritedResources::Base

  skip_before_filter :authenticate_user!, :only => [:show, :not_found]
  before_filter :authorize_resource, only: [:edit, :update, :destroy]
  #before_filter :ensure_admin, :except => [:show, :not_found]

  def index
    authorize build_resource
    index!
  end

  def show
    authorize resource
  rescue ActiveRecord::RecordNotFound => e
    raise e unless User.is_admin? current_user
    authorize(build_resource, :new?)
    redirect_to new_content_path key: params[:id]
  end

  def new
    authorize build_resource
    resource.key = refined_params[:key] if refined_params[:key]
    new!
  end

  def create
    authorize build_resource
    create! notice: 'Content was successfully created.'
  end

  def update
    update! notice: 'Content was successfully updated.' do
      return_to_path(@content, clear: true)
    end
  end
end
