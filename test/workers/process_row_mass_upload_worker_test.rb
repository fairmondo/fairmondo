
require "test_helper"

describe ProcessRowMassUploadWorker do
  it "should cover exhausted row workers" do
    Sidekiq.logger.stubs(:warn)
    mu = FactoryGirl.create :mass_upload
    ProcessRowMassUploadWorker.sidekiq_retries_exhausted_block.call({"class" => Object.class , "args" => [mu.id,"lala",3], "error_message" => "snafu"})
  end
end