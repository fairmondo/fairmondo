require 'spec_helper'

describe CategoryPolicy do
  include PunditMatcher

  it { should grant_permission(:select_category) }
  it { should grant_permission(:show) }
end
