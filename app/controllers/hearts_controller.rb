class HeartsController < ApplicationController
  respond_to :html
  skip_before_filter :authenticate_user!, only: [:create]

  def create
    if user_signed_in?
      @user = current_user
    else
      @user = nil
    end

    @library = Library.find(params[:library_id])
    user_token = generate_user_token(request.env['HTTP_USER_AGENT'], request.env['REMOTE_ADDR'])
    @heart = @library.hearts.build(user_token: user_token, user: @user)
    authorize @heart
    #require 'pry'; binding.pry
    respond_with @library, @heart do |format|
      if @heart.save
        format.js
      else
        format.js { render json: @heart.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  end

  private
    def generate_user_token(agent, addr)
      Digest::SHA2.hexdigest(agent + addr)
    end
end