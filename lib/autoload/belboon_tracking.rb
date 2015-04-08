## Affiliate network stuff
## Belboon, see https://www.belboon.com

module BelboonTracking
  private

    def save_belboon_tracking_token_in_session
      session[:belboon] ||= params[:belboon]
    end

    def save_belboon_tracking_token_in_user
      if session[:belboon]
        current_user.update_attributes(
          belboon_tracking_token: session[:belboon],
          belboon_tracking_token_set_at: Time.now
        )
        session[:belboon] = nil
      end
    end

    def clear_belboon_tracking_token_from_user
      if current_user.belboon_tracking_token
        clear_token
      end
    end

    def clear_void_belboon_tracking_token_from_user
      if current_user.belboon_tracking_token &&
         current_user.belboon_tracking_token_set_at < 1.week.ago
        clear_token
      end
    end

    def clear_token
      current_user.update_attributes(belboon_tracking_token: nil,
                                     belboon_tracking_token_set_at: nil)
    end
end
