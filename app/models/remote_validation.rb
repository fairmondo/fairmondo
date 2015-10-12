#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

# non ActiveRecord object, handles specific validations
class RemoteValidation < Struct.new(:model, :field, :value, :additional_params)
  # custom dependent enumerization
  PERMITTED_FIELDS = {
    'line_item' => ['requested_quantity'],
    'article' => %w(title quantity transport_time price)
  }

  def initialize model, field, value, additional_params
    raise 'Model not allowed' unless PERMITTED_FIELDS.keys.include? model
    raise 'Field not allowed' unless PERMITTED_FIELDS[model].include? field
    super model, field, value, additional_params
  end

  def errors
    validator = create_validator
    validator.valid? # execute validations
    validator.errors[field]
  end

  private

  def create_validator
    if additional_params['id'] # is update
      validator = model.classify.constantize.find additional_params['id']
      validator.send "#{field}=", value
    else # is create
      validator = model.classify.constantize.new field => value
    end
    additional_params.each { |k, v| validator.send("#{k}=", v) unless k == 'id' } # assign other supporting fields
    validator
  end
end
