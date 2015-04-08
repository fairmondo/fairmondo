module QuestionnaireInitializer
  # Whoever wrote this method - please document and write tests for it
  def initialize(*args)
    if args.present?
      args[0].select{|k,_v| k.match(/_checkboxes$/)}.each_pair do |k, v|
        args[0][k] = v.reject(&:empty?)
      end
    end
    super
  end
end
