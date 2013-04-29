class MessagesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @inbox = current_user.messages_received
    @outbox = current_user.messages_sent
  end

  def show
    @message = Message.find params[:id]

    if (@message.sender_id != current_user.id && @message.recipient_id != current_user.id)
      flash[:error] = 'Sie haben keine Berechtigung, diese Nachricht anzuzeigen.'
      redirect_to messages_path
    end
  end

  def new
    if current_user.id == params[:id].to_i
      flash[:error] = 'Sie koennen keine Nachricht an sich selbst schreiben.'
      redirect_to dashboard_path
    end

    @recipient = User.find params[:id]
    @message = Message.new recipient_id: params[:id]
  end

  def create
    @message = Message.new params[:message]

    @message.message_sender = current_user

    if @message.save
      respond_to do |format|
        format.html { redirect_to @message, notice: 'Nachricht erfolgreich abgeschickt.' }
        format.json { render json: @message, status: :created }
      end
    else
      @recipient = User.find @message.recipient_id
      flash[:error] = 'Bitte alle Felder ausfuellen.'
      render action: 'new'
    end
  end
end
