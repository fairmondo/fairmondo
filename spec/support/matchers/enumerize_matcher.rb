#
# Farinopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Farinopoly.
#
# Farinopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Farinopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Farinopoly.  If not, see <http://www.gnu.org/licenses/>.
#
# ---
# RSpec matcher to spec enumerize settings
# usage:
#
# it { should enumerize(:sex).in(:male, :female).with_default(:male) }
#
# @from https://gist.github.com/jumski/2318858
# @deprecated Remove as soon as it's a regular rspec mathcer. See https://github.com/brainspec/enumerize/issues/31
#
RSpec::Matchers.define :enumerize do |attribute|
  match do |model|
    @attribute = attribute
    @klass = model.class

    @valid = true
    @valid&= klass_enumerized?
    @valid&= has_enum?
    @valid&= in_values_matches? if @in
    @valid&= default_value_matches? if @default
    @valid
  end

  chain(:in)           { |*values| @in = values }
  chain(:with_default) { |default| @default = default }

  description do
    desc = "enumerize :#@attribute"
    desc+= " in #{human_readable_values(expected_in_values)}" if @in
    desc+= " with default of :#{@default}" if @default
    desc
  end

  failure_message_for_should do |text|
    if @in and not in_values_matches?
      msg = "expected :#@attribute to allow values #{human_readable_values(expected_in_values)}"
      msg+= ", but it allows #{human_readable_values(actual_in_values)} instead"
    end

    if @default and not default_value_matches?
      msg = "expected :#@attribute to have default of :#{@default}, got #{default_value || 'nil'} instead"
    end

    msg = "does not include Enumerize" unless klass_enumerized?
    msg = "expected to enumerize attribute :#{@attribute}" unless has_enum?

    msg
  end

  def klass_enumerized?
    @klass.respond_to? :enumerized_attributes
  end

  def has_enum?
    enum_attrs.find do |enum_attr|
      enum_attr.first.to_sym == @attribute
    end
  end

  def actual_in_values
    values = enum_attrs[@attribute.to_s].instance_variable_get :@values
    return values.map(&:to_sym) if values
    []
  end

  def expected_in_values
    return @in.map(&:to_sym) if @in
    []
  end

  def in_values_matches?
    actual_in_values.sort == expected_in_values.sort
  end

  def default_value
    value = enum_attrs[@attribute.to_s].instance_variable_get :@default_value
    value.try :to_sym
  end

  def default_value_matches?
    default_value && default_value == @default
  end

  def enum_attrs
    @klass.enumerized_attributes.instance_variable_get :@attributes
  end

  def human_readable_values(ins)
    "[#{ins.map{|i| ":#{i}"}.join(', ')}]"
  end

end
