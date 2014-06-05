# Shared functionality for refineries,
# unless inherited this class will not
# do anything.
class ApplicationRefinery < Arcane::Refinery

  # InheritedResources automatically calls params on resources and
  # build_resource, this means every action will call a refinery.
  # "root false" says, that there is no required root like "article:"
  # in the params, because those only exist for create, update. Arcane
  # assumes by default that it will only be used for those.
  #def root
   # false
  #end

  # Those do use root by default. Remember to add use_root when overwriting.
  #def create
   # default
  #end
  #def update
   # default
  #end
end
