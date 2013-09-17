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
require_dependency "tinycms/application_controller"

module Tinycms
  class ContentsController < ApplicationController

    before_filter :authenticate_tinycms_user, :except => [:show, :not_found]
    before_filter :ensure_admin, :except => [:show, :not_found]

    def index
      @contents = Content.all
    end

    def show
      if tinycms_admin?
        begin
          @content = Content.find(params[:id])
        rescue ActiveRecord::RecordNotFound => e
          @content = Content.new(:key => params[:id])
          render "new"
        end
      else
        @content = Content.find(params[:id])
      end
    end

    def new
      @content = Content.new
    end

    def edit
      session[:return_to] ||= request.referer
      @content = Content.find(params[:id])
    end

    def create
      @content = Content.new(params[:content])

      respond_to do |format|
        if @content.save
          format.html { redirect_to @content, notice: 'Content was successfully created.' }
        else
          format.html { render "new" }
        end
      end
    end

    def update
      @content = Content.find(params[:id])

      respond_to do |format|
        if @content.update_attributes(params[:content])
          format.html {
            redirect_to(return_to_path(@content, :clear => true),
              notice: 'Content was successfully updated.')
            }
        else
          format.html { render "edit" }
        end
      end
    end

    def destroy
      @content = Content.find(params[:id])
      @content.destroy

      respond_to do |format|
        format.html { redirect_to contents_url }
      end
    end
  end
end
