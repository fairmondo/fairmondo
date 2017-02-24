#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module HeartsHelper
  # Wraps the layout call and sanitizes the options
  #
  # param heartable_resource: the resource that the user can heart.
  # @return [String] The compiled HTML of the button element
  def heart_button(heartable_resource)
    if user_signed_in?
      heart = Heart.where(heartable: heartable_resource, user: current_user).limit 1
    else
      heart = Heart.where(heartable: heartable_resource, user_token: generate_user_token).limit 1
    end

    if heart.to_a.empty?
      render partial: 'hearts/heart_button', locals: {
        heartable_resource: heartable_resource,
        filled: false,
        path: library_hearts_path(heartable_resource),
        method: :post,
        disabled: false
      }
    else
      if user_signed_in?
        render partial: 'hearts/heart_button', locals: {
          heartable_resource: heartable_resource,
          filled: true,
          path: library_heart_path(heartable_resource, heart.first),
          method: :delete,
          disabled: false
        }
      else
        render partial: 'hearts/heart_button', locals: {
          heartable_resource: heartable_resource,
          disabled: true
        }
      end
    end
  end

  def generate_user_token
    UserTokenGenerator.generate(request.env['HTTP_USER_AGENT'], request.env['REMOTE_ADDR'])
  end
end
