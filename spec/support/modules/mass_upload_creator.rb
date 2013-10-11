module MassUploadCreator

  def create_attributes(path, format)
    ActiveSupport::HashWithIndifferentAccess.new(
      file: fixture_file_upload(path, format)
    )
  end

  def create_mass_upload(path, format)
    # user = FactoryGirl::create(:user)
    MassUpload.new(create_attributes(path, format))
  end
end