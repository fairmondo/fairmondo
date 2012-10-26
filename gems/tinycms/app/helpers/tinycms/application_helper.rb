module Tinycms
  module ApplicationHelper
    include Tinycms::Helper
        
    def return_to_path(fallback, options = {})
      return session.delete(:return_to) || fallback if options[:clear] 
      session[:return_to] || fallback
    end
    
    # still ugly
    # see http://stackoverflow.com/questions/7588870/engine-routes-in-application-controller
    # http://stackoverflow.com/questions/9232175/access-main-app-helpers-when-overridings-a-rails-engine-view-layout
    # all approaches had their gochtas / didn't work
    # 
    # TODO remove namespacing and isolate_namespace
    # or iterate throug main_app methods and define
    #
    # also see http://www.candland.net/2012/04/17/rails-routes-used-in-an-isolated-engine/
    # 
    def method_missing method, *args, &block
      if method.to_s.end_with?('_path') || method.to_s.end_with?('_url')
        if main_app.respond_to?(method)
          main_app.send(method, *args)
        else
          super
        end
      else
        super
      end
    end

    def respond_to?(method, *args)
      if method.to_s.end_with?('_path') || method.to_s.end_with?('_url')
        if main_app.respond_to?(method)
          true
        else
          super
        end
      else
        super
      end
    end
    
  end
end
