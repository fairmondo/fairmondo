require 'rss'
require 'timeout'

class ToolboxController < ApplicationController
  respond_to :js, :json

  skip_before_filter :authenticate_user!, only: [ :session_expired, :confirm, :rss, :reload, :healthcheck ]

  def session_expired
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
    @items = get_feed_items
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def notice
    notice = Notice.find params[:id]
    notice.update_attribute :open, false
    redirect_to URI.parse(notice.path).path
  end

  # A site that's sole purpose is to reload the browser. Only useful for AJAX requests
  def reload
    render layout: false
  end

  def reindex
    raise Pundit::NotAuthorizedError unless current_user.admin?
    Indexer.index_article Article.find(params[:article_id])
    redirect_to :back, notice: I18n.t('article.show.reindexed')
  end

  # Send a single email to a private user, should be refactored when we have a real messaging system
  def contact
    session[:seller_message] = {} unless session[:seller_message]
    session[:seller_message][params[:contact][:article_id]] = params[:contact][:text] # store text
    return redirect_to :back, flash: { error: I18n.t('article.show.contact.acceptance_error') } unless params[:contact][:email_transfer_accepted] == "1" # manual validation: transfer of email was accepted
    return redirect_to :back, flash: { error: I18n.t('article.show.contact.empty_error') } unless params[:contact][:text].length > 0 # manual validation: message is present
    return redirect_to :back, flash: { error: I18n.t('article.show.contact.long_error') } unless params[:contact][:text].length < 2000 # manual validation: message is shorter than 2000 characters
    article = Article.find params[:contact][:article_id]
    ArticleMailer.contact(current_user.email, article.seller_email, params[:contact][:text], article).deliver
    session[:seller_message][params[:contact][:article_id]] = nil # delete from session
    redirect_to article, notice: I18n.t('article.show.contact.success_notice')
  end

  def healthcheck
    render layout: false
  end

  private
    def get_feed_items
      begin
        Timeout::timeout(10) do #10 second timeout
          OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:ssl_version] = 'SSLv3' # See comment to http://stackoverflow.com/q/20169301/409087
                                                                           # TODO Set /etc/ssl/certs as sll_ca_folder to remove this hack
          feed = open 'https://info.fairnopoly.de/?feed=rss', ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE
          OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:ssl_version] = 'SSLv23'

          rss = RSS::Parser.parse(feed.read, false)
          rss.items.first(3)
        end
      rescue Timeout::Error
        nil
      end
    end
end
