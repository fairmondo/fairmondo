#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class ProcessRowMassUploadWorkerTest < ActiveSupport::TestCase
  it 'should cover exhausted row workers' do
    Sidekiq.logger.stubs(:warn)
    mu = create :mass_upload
    ProcessRowMassUploadWorker.sidekiq_retries_exhausted_block.call('class' => Object.class, 'args' => [mu.id, 'lala', 3], 'error_message' => 'snafu')
  end
end
