#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class HeartsController < ApplicationController
  include FindPolymorphicTarget

  # If you want another Model to be heartable,
  # add it to the array below, please.
  HEARTABLES = [Library]

  respond_to :js

  skip_before_action :authenticate_user!, only: :create
  before_action() { set_heartable(HEARTABLES) }

  def create
    if user_signed_in?
      @heart = @heartable.hearts.build(user: current_user)
    else
      user_token = UserTokenGenerator.generate(request.env['HTTP_USER_AGENT'], request.env['REMOTE_ADDR'])
      @heart = @heartable.hearts.build(user_token: user_token)
    end

    authorize @heart

    if @heart.save
      # In the view we are using the hearts_count counter cache, which is not automatically
      # updated in the object, so we do it by hand.
      # Please don't save this object from now on.
      @heartable.hearts_count += 1
    else
      @message = 'Jemand hat diese Sammlung schon von diesem Computer geherzt. ' +
                 'Wenn du das nicht warst, logge dich bitte ein!'
    end
  end

  def destroy
    @heart = Heart.find(params[:id])
    authorize @heart
    @heart.destroy

    # In the view we are using the hearts_count counter cache, which is not automatically
    # updated in the object, so we do it by hand.
    # Please don't save this object from now on.
    @heartable.hearts_count -= 1
  end
end
