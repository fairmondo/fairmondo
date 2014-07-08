# non ActiveRecord object, handles specific validations
class RemoteValidation < Struct.new(:model, :field, :value, :additional_params)
  # custom dependent enumerization
  PERMITTED_FIELDS = {
    'line_item' => [ 'requested_quantity' ]
  }

  def initialize model, field, value, additional_params
    raise "Model not allowed" unless PERMITTED_FIELDS.keys.include? model
    raise "Field not allowed" unless PERMITTED_FIELDS[model].include? field
    super model, field, value, additional_params
  end

  def errors
    if additional_params['id']
      validator = model.classify.constantize.find additional_params['id']
      validator.send "#{field}=", value
    else
      validator = model.classify.constantize.new field => value
    end
    additional_params.each { |k,v| validator.send("#{k}=", v) unless k == 'id' }

    validator.valid? # execute validations
    validator.errors[field]
  end
end
