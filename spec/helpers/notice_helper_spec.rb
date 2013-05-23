require "spec_helper"

describe NoticeHelper do
  # describe "#bootstrap_notice_mapper" do
  #   it "returns 'warning' when given :alert" do
  #     helper.bootstrap_notice_mapper(:alert).should eq 'warning'
  #   end
  #   it "returns 'error' when given :error" do
  #     helper.bootstrap_notice_mapper(:error).should eq 'error'
  #   end
  #   it "returns 'success' when given :notice" do
  #     helper.bootstrap_notice_mapper(:notice).should eq 'success'
  #   end
  #   it "returns 'info' when given anything else" do
  #     helper.bootstrap_notice_mapper(:thissymboldoesntexist).should eq 'info'
  #   end
  # end

  describe "#main_notice_mapper" do
    it "returns 'error' when given :alert" do
      helper.main_notice_mapper(:alert).should eq 'error'
    end
    it "returns 'error' when given :error" do
      helper.main_notice_mapper(:error).should eq 'error'
    end
    it "returns 'info' when given :notice" do
      helper.main_notice_mapper(:notice).should eq 'info'
    end
    it "returns 'info confirmation' when given :confirm" do
      helper.main_notice_mapper(:confirm).should eq 'info confirmation'
    end
    it "returns 'info' when given anything else" do
      helper.main_notice_mapper(:thissymboldoesntexist).should eq 'info'
    end
  end
end