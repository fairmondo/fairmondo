require 'rss'

class ToolboxController < ApplicationController
  respond_to :js, :json

  skip_before_filter :authenticate_user!, only: [ :session,:confirm,:rss ]

  def session
    respond_to do |format|
      #Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name) #for testing purposes
      format.json { render status: 200, json: { expired: current_user.nil? } }
    end
  end

  def confirm
    respond_to do |format|
      format.js
    end
  end

  def rss
    rss = RSS::Parser.parse(open('http://info.fairnopoly.de/?feed=rss').read,false)
    @items = rss.items.first(3)
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def notice
    notice = Notice.find params[:id]
    notice.update_attribute(:open,false)
    redirect_to notice.path
  end

end
