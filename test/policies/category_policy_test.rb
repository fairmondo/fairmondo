require_relative '../test_helper'

describe CategoryPolicy do
  include PunditMatcher

  it { subject.must_permit(:select_category) }
  it { subject.must_permit(:show) }
end
