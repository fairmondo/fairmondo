require 'spec_helper'

describe Auction do

  let(:auction) { FactoryGirl::create(:auction)}

  it {should have_many :images}

  it {should belong_to :seller}
  it {should belong_to :category}
  it {should belong_to :alt_category_1}
  it {should belong_to :alt_category_2}

end