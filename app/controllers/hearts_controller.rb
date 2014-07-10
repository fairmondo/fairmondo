class HeartsController < ApplicationController
  # If you want another Model to be heartable,
  # add it to the array below, please.
  HEARTABLES = [Library]

  respond_to :js

  skip_before_filter :authenticate_user!, only: :create
  before_filter :set_heartable

  def create
    if user_signed_in?
      @heart = @heartable.hearts.build(user: current_user)
    else
      user_token = generate_user_token(request.env["HTTP_USER_AGENT"],
                                       request.env["REMOTE_ADDR"])
      @heart = @heartable.hearts.build(user_token: user_token)
    end
    authorize @heart
    if !@heart.save
      @message = "Jemand hat diese Sammlung schon von diesem Computer geherzt. " +
                 "Wenn du das nicht warst, logge dich bitte ein!"
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

  # Infer the heartable class from the params hash
  #
  def set_heartable
    heartable_key = params.keys.select { |p| p.match(/[a-z_]_id$/) }.last

    # Class can be inferred from the key.
    # We're using the HEARTABLES array for protection though.
    heartable_class = HEARTABLES.select do |klass|
      klass.to_s.downcase == heartable_key[0..-4]
    end.first

    @heartable = heartable_class.find(params[heartable_key])
  end
end
