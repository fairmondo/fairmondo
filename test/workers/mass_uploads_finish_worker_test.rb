#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class MassUploadsFinishWorkerTest < ActiveSupport::TestCase
  it 'finishes a processing mass_upload' do
    mass_upload = create(:mass_upload_to_finish)
    MassUploadsFinishWorker.new.perform
    mass_upload.reload
    mass_upload.state.must_equal 'finished'
  end
end
