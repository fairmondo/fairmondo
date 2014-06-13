#
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
module PunditMatcher
#  extend RSpec::Matchers::DSL
#
#  matcher :grant_permission do |action|
#    match do |policy|
#      get_return_of_send policy, action
#    end
#
#    failure_message_for_should do |policy|
#      "#{policy.class} does not permit '#{action}' for user: #{policy.user.inspect}."
#    end
#
#    failure_message_for_should_not do |policy|
#      "#{policy.class} does not forbid '#{action}' for user: #{policy.user.inspect}."
#    end
#  end
#
#  matcher :deny do |action|
#    match do |policy|
#      !get_return_of_send policy, action
#    end
#
#    failure_message_for_should do |policy|
#      "#{policy.class} does not deny '#{action}' for user: #{policy.user.inspect}."
#    end
#  end
#
#  # "ultimately": check if not only the policy permits or denies a user, but also
#  #               if the authorization lets a user get there in the first place
#
#  matcher :ultimately_deny do |action|
#    match do |policy|
#      if check_devise_auth_on policy, action
#        true
#      else
#        !get_return_of_send policy, action
#      end
#    end
#
#    failure_message_for_should do |policy|
#      "#{policy.class} does not ultimately deny '#{action}' for user: #{policy.user.inspect}."
#    end
#  end
#
#
#  def get_return_of_send policy, action
#    allow_message_expectations_on_nil
#    policy.user.stub(:id).and_return(999) unless policy.user # prevent nil.id errors from own?
#    policy.public_send "#{action}?"
#  end
#
#  def check_devise_auth_on policy, action
#    # check if base class is already devise authorized
#    controller = eval("#{policy.class.to_s[0..-7].pluralize}Controller")
#    define_before_filter_getter_for controller
#    controller.has_before_filter_of_type? :authenticate_user!, action
#  end
#
#  def define_before_filter_getter_for controller
#    # This is the method we want on a controller for testing purposes:
#    has_before_filter_of_type = proc do |filter, action_name|
#      all_filters = _process_action_callbacks
#      filter_hash = all_filters.select{ |f| f.kind == :before && f.filter == filter }[0]
#
#      if filter_hash && action_name
#        if filter_hash.instance_variable_get(:@unless) && !filter_hash.instance_variable_get(:@unless).empty?
#          !eval(filter_hash.instance_variable_get(:@unless)[0]) # these describe actions excluded from the filter. returns true => action doesnt have filter
#        elsif filter_hash.instance_variable_get(:@if) && !filter_hash.instance_variable_get(:@if).empty?
#          eval(filter_hash.instance_variable_get(:@if)[0]) # these describe actions including the filter. returns true => action has filter
#        else
#          true # every action gets the before filter
#        end
#      else
#        false
#      end
#    end
#
#    # Now we set the method to the currently used controller:
#    metaclass = class << controller; self; end
#    metaclass.send :define_method, :has_before_filter_of_type?, has_before_filter_of_type
#  end
end
