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

  # Send a single email to a private user, should be refactored when we have a real messaging system
  def contact
    return redirect_to :back, flash: { error: I18n.t('article.show.contact.acceptance_error') } unless params[:contact][:email_transfer_accepted] == "1" # manual validation: transfer of email was accepted
    return redirect_to :back, flash: { error: I18n.t('article.show.contact.empty_error') } unless params[:contact][:text].length > 0 #manual validation: message is present
    article = Article.find params[:contact][:article_id]
    raise Pundit::NotAuthorizedError unless current_user || article.seller.is_a?(PrivateUser) #manual authorize
    ArticleMailer.contact(current_user.email, article.seller_email, params[:contact][:text], article).deliver
    redirect_to article, notice: I18n.t('article.show.contact.success_notice')
  end
end
