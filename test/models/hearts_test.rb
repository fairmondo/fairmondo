require_relative "../test_helper"

class HeartTest < ActiveSupport::TestCase
  subject { Heart.new }

  describe "model attributes" do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
    it { subject.must_respond_to :heartable_id }
    it { subject.must_respond_to :heartable_type }
    it { subject.must_respond_to :user_id }
    it { subject.must_respond_to :user_token }
  end

  describe "associations" do
    it { subject.must belong_to :heartable }
    it { subject.must belong_to :user  }
  end

  let (:heart) { Heart.new }
  let (:user) { FactoryGirl.create(:user) }
  let (:heartable) { FactoryGirl.create(:library) }

  describe "validations" do
    it { subject.must validate_presence_of(:user) }
    it { subject.must validate_presence_of(:heartable) }
  end

  describe "database uniqueness index" do
    let (:second_heart) { Heart.new(user: user, heartable: heartable) }

    before do
      heart.user = user
      heart.heartable = heartable
    end

    it "saves a Heart with user and heartable" do
      assert heart.save
    end

    it "barfs when trying to save a second heart" do
      heart.save
      assert_raises(ActiveRecord::RecordInvalid) { second_heart.save! }
    end
  end
end
