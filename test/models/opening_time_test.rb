require_relative '../test_helper'

describe OpeningTime do
  let(:opening_times) { OpeningTime.new }
  subject { opening_times }

  describe 'atttributes' do
    it { subject.must_respond_to :user_id }
    it { subject.must_respond_to :monday }
    it { subject.must_respond_to :tuesday }
    it { subject.must_respond_to :wednesday }
    it { subject.must_respond_to :thursday }
    it { subject.must_respond_to :friday }
    it { subject.must_respond_to :saturday }
    it { subject.must_respond_to :sunday }
  end

  describe 'associations' do
    it { subject.must belong_to(:user) }
  end

  it "must be valid" do
    opening_times.must_be :valid?
  end
end
