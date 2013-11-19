class MassUploadObserver < ActiveRecord::Observer

  def after_create(mass_upload)
    mass_upload.process
  end

end