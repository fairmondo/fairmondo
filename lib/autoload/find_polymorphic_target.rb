module FindPolymorphicTarget
  # This module sets the target for hearts and comments

  %w(heartable commentable).each do |target|
    define_method("set_#{target}") do |klasses|
      target_key = params.keys.select { |p| p.match(/[a-z_]_id$/) }.last

      # Class can be inferred from the key.
      # We're using an array for protection though.
      target_class = klasses.select do |klass|
        klass.to_s.downcase == target_key[0..-4]
      end.first

      instance_variable_set("@#{target}", target_class.find(params[target_key]))
    end
  end
end
