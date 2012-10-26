class Tinycms::ApplicationController < ApplicationController
  include Tinycms::ApplicationHelper
  private
  unless method_defined? :authenticate_tinycms_user
    if method_defined? :authenticate_user!
      def authenticate_tinycms_user
        authenticate_user!
      end
    else
      warn "Tinycms: Please define 'authenticate_tinycms_user' in your ApplicationController"
      def authenticate_tinycms_user
      end
    end
  end
  
=begin

  unless method_defined? :tinycms_user
    if method_defined? :current_user
      define_method :tinycms_user do 
        current_user
      end
    else
      raise "Tinycms: Please define 'tincms_user' in your ApplicationController"
    end
  end
  helper_method :tinycms_user

  unless method_defined? :tinycms_admin?
    def tinycms_admin?
      tinycms_user && tinycms_user.admin?
    end
  end
  helper_method :tinycms_admin?
=end

end
