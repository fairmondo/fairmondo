#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'rss'
require 'timeout'

class ToolboxController < ApplicationController
  respond_to :js, :json

  skip_before_action :authenticate_user!, only: [:session_expired, :confirm, :rss, :reload, :healthcheck]

  def session_expired
    respond_to do |format|
      # Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name) #for testing purposes
      format.json { render status: 200, json: { expired: current_user.nil? } }
    end
  end

  def confirm
    respond_to do |format|
      format.js
    end
  end

  def rss
    @items = acquire_feed_items
    respond_to do |format|
      format.html { render layout: false }
    end
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
    @contact_form = ContactForm.new(params[:contact_form])
    if @contact_form.valid?
      @contact_form.mail current_user, params[:resource_id], params[:resource_type]
    end
  end

  def healthcheck
    render layout: false
  end

  def newsletter_status
    is_subscribed = CleverreachAPI.get_status(current_user)

    if current_user.newsletter != is_subscribed
      current_user.update_column :newsletter, is_subscribed
    end

    render json: { subscribed: is_subscribed }
  end

  private

  def acquire_feed_items
    begin
      Timeout.timeout(10) do # 10 second timeout
        OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:ssl_version] = 'SSLv23' # See comment to http://stackoverflow.com/q/20169301/409087
        # TODO Set /etc/ssl/certs as sll_ca_folder to remove this hack
        feed = open 'https://info.fairmondo.de/?feed=rss', ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE
        OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:ssl_version] = 'SSLv23'

        rss = RSS::Parser.parse(feed.read, false)
        rss.items.first(3)
      end
    rescue Timeout::Error
      nil
    end
  end
end
