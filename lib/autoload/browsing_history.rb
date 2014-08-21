# visited urls history, for after login redirection and feedbacks
# @TODO prevent devise from clearing this after sign_out
module BrowsingHistory
  protected
    # store up to MAX_STORED_STEPS requests in session
    def store_location
      ensure_session_key
      unless last_url_hash[:path] == new_url_hash[:path] and last_url_hash[:method] == new_url_hash[:method] # store unique requests only
        new_url_hash[:params] = recursive_stringify(request.params) if should_store_params?
        session[:previous_urls].prepend new_url_hash
      end
      session[:previous_urls].pop if session[:previous_urls].count > MAX_STORED_STEPS
      true
    end

    # @return [String] most recently called redirectable path
    def redirect_back_location
      ensure_session_key
      session[:previous_urls].each do |url_hash|
        return url_hash[:path] if redirectable_url?(url_hash)
      end
      nil
    end

  # pseudo private (functions should only be called from this module)

    MAX_STORED_STEPS = 10

    def ensure_session_key
      session[:previous_urls] ||= []
    end

    def should_store_params?
      new_url_hash[:method] != 'GET' and
      !DISABLED_PARAMS_STORE_URLS.include? new_url_hash[:path]
    end
    DISABLED_PARAMS_STORE_URLS = ["/feedbacks", "/user/sign_in"]

    def redirectable_url? url_hash
      url_hash[:method] == "GET" and
      !url_hash[:xhr] and
      !DISABLED_REDIRECT_URLS.include?(url_hash[:path])
    end
    DISABLED_REDIRECT_URLS = ["/user/sign_up","/user/sign_in","/user/sign_out","user/confirmation"]

    def last_url_hash
      @last_url_hash ||= session[:previous_urls].first || {}
    end

    def new_url_hash
      @new_url_hash ||= {
        method: request.method,
        path: request.fullpath,
        xhr: !!request.xhr?,
        time: Time.now
      }
    end

    # when saving params we need a multi-dimensional hash with only strings,
    # other objects create trouble later on
    def recursive_stringify hash
      hash.each_key do |key|
        if hash[key].is_a? Hash
          recursive_stringify hash[key]
        elsif not hash[key].is_a? String
          hash[key] = hash[key].inspect
        end
      end
    end
end
