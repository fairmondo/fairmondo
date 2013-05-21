module PunditMatcher
  extend RSpec::Matchers::DSL

  matcher :permit do |action|
    match do |policy|
      get_return_of_send policy, action
    end

    failure_message_for_should do |policy|
      "#{policy.class} does not permit '#{action}' for user: #{policy.user.inspect}."
    end

    failure_message_for_should_not do |policy|
      "#{policy.class} does not forbid '#{action}' for user: #{policy.user.inspect}."
    end
  end

  matcher :deny do |action|
    match do |policy|
      !get_return_of_send policy, action
    end

    failure_message_for_should do |policy|
      "#{policy.class} does not deny '#{action}' for user: #{policy.user.inspect}."
    end
  end

  # "ultimately": check if not only the policy permits or denies a user, but also
  #               if the authorization lets a user get there in the first place

  matcher :ultimately_deny do |action|
    match do |policy|
      if check_devise_auth_on policy, action
        true
      else
        !get_return_of_send policy, action
      end
    end

    failure_message_for_should do |policy|
      "#{policy.class} does not ultimately deny '#{action}' for user: #{policy.user.inspect}."
    end
  end

  # matcher :ultimately_permit do |action|
  #   match do |policy|
  #     if check_devise_auth_on policy, action
  #       false
  #     else
  #       get_return_of_send policy, action
  #     end
  #   end

  #   failure_message_for_should do |policy|
  #     "#{policy.class} does not ultimately permit '#{action}' for user: #{policy.user.inspect}."
  #   end
  # end



  protected

  def get_return_of_send policy, action
    allow_message_expectations_on_nil
    policy.user.stub(:id).and_return(999) unless policy.user # prevent nil.id errors from own?
    policy.public_send "#{action}?"
  end

  def check_devise_auth_on policy, action
    # check if base class is already devise authorized
    controller = eval("#{policy.class.to_s[0..-7].pluralize}Controller")
    controller.has_before_filter_of_type? :authenticate_user!, action
  end
end
