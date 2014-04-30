# Monkey patch with permission from the gem's README (kinda)
module InheritedResources
  module BaseHelpers
    private
    # Strong_parameters' params getter. One might think it's a bad idea to
    # overwrite this internal method, but they say to do so in the main README.
    # Arcane needs params.require statements.
    def build_resource_params
      object = controller_name.classify.constantize.new rescue nil
      user = current_user rescue User.new
      [params.for(object).as(user).refine]
    end
  end
end