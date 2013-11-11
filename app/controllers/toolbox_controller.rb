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
    rss = RSS::Parser.parse(open('http://info.fairnopoly.de/?feed=rss').read, false)
    @items = rss.items.first(3)
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def notice
    notice = Notice.find params[:id]
    notice.update_attribute :open, false
    redirect_to URI.parse(notice.path).path
  end

  # Send a single email to a private user
  def contact
    return redirect_to :back, flash: { error: 'Bla' } unless params[:contact][:email_transfer_accepted] == "1" # manual validation: transfer of email was accepted
    return redirect_to :back, flash: { error: 'Keks' } unless params[:contact][:text].length > 0 #manual validation: message is present
    article = Article.find params[:contact][:article_id]
    return redirect_to :back, flash: { error: 'Nee' } unless article.seller.is_a? PrivateUser #manual validation: seller is a private user
    ArticleMailer.contact current_user.email, article.seller_email, params[:contact][:text]
    redirect_to article, notice: 'Yeah'
  end
end
