class ExhibitsController < InheritedResources::Base
  actions :create,:update

  def create
    authorize build_resource
    create! do |format|
      format.html {redirect_to resource.article}
    end
  end

  def update
    authorize resource
    update! do |format|
      format.html {redirect_to resource.article}
    end
  end

end
