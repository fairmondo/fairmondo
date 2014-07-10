class HeartsController < ApplicationController
  respond_to :js
  skip_before_filter :authenticate_user!, only: :create

  before_filter :set_library

  def create
    if user_signed_in?
      @heart = @library.hearts.build(user: current_user)
    else
      user_token = generate_user_token(request.env['HTTP_USER_AGENT'], request.env['REMOTE_ADDR'])
      @heart = @library.hearts.build(user_token: user_token)
    end

    authorize @heart
    if !@heart.save
      @message = "Jemand hat diese Sammlung schon von diesem Computer geherzt. Wenn du das nicht warst, logge dich bitte ein"
    end
  end

  def destroy
    @heart = Heart.find(params[:id])
    authorize @heart
    @heart.destroy
  end

  private
    def generate_user_token(agent, addr)
      Digest::SHA2.hexdigest(agent + addr)
    end

    def set_library
      @library = Library.find(params[:library_id])
    end
end