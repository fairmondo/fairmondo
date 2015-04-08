require 'test_helper'

describe MassUploadsFinishWorker do
  it 'finishes a processing mass_upload' do
    mass_upload = FactoryGirl.create(:mass_upload_to_finish)
    MassUploadsFinishWorker.new.perform
    mass_upload.reload
    mass_upload.state.must_equal 'finished'
  end
end
