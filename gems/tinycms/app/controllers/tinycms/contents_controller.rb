require_dependency "tinycms/application_controller"

module Tinycms
  class ContentsController < ApplicationController

    before_filter :authenticate_tinycms_user, :except => [:show, :not_found]

    def index
      @contents = Content.all
    end

    def show
      if tinycms_admin?
        begin
          @content = Content.find(params[:id])
        rescue ActiveRecord::RecordNotFound => e
          @content = Content.new(:key => params[:id])
          render action: "new"
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
          format.html { render action: "new" }
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
          format.html { render action: "edit" }
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
