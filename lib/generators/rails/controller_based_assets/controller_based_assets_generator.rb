class Rails::ControllerBasedAssetsGenerator < Rails::Generators::NamedBase
  def create_assets_file
    #create_file "app/assets/javascripts/#{file_name}.js", <<-FILE
    #FILE
    create_file "app/assets/stylesheets/controller/#{file_name}.css.scss", <<-FILE
    FILE
  end
end