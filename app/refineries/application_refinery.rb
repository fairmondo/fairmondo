# Shared functionality for refineries,
# unless inherited this class will not
# do anything.
class ApplicationRefinery < Arcane::Refinery

  # InheritedResources automatically calls params on resources and
  # build_resource, this means every action will call a refinery.
  # "root false" says, that there is no required root like "article:"
  # in the params, because those only exist for create, update. Arcane
  # assumes by default that it will only be used for those.
  def root
    false
  end

  # Those do use root by default. Remember to add use_root when overwriting.
  def create
    use_root
    default
  end
  def update
    use_root
    default
  end

  protected
    # To not have to give the root for every place where it is actually
    # needed, this helper adds it manually
    def use_root root = nil
      unless root # get root from refinery's class name
        root = self.class.to_s[0..-9].underscore
      end

      # And for my next trick, I will make a method appear out of thin air:
      klass = class << self; self; end
      klass.class_eval do
        self.send :define_method, :root do
          root
        end
      end
      # Magic!
    end
end