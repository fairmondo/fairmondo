require 'spec_helper'

describe Ffp do  
  
  it "has a valid Factory" do
    FactoryGirl.create(:ffp).should be_valid
  end
  
  let(:ffp) { FactoryGirl::create(:ffp)}

  it { should belong_to :donator}

  it {should validate_presence_of :price}

  it {should validate_numericality_of :price}

end