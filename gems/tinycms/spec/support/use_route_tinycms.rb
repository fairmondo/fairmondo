module UseRouteTinycms
  [:get, :post, :put, :delete].each do |method_name|
    define_method(method_name) do |action, parameters = nil, *args|
      parameters ||= {}
      parameters = parameters.merge!(:use_route => :tinycms)
      super(action, parameters, *args)
    end
  end
end