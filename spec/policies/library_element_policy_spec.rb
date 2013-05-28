require 'spec_helper'

describe LibraryElementPolicy do
  include PunditMatcher

  subject { LibraryElementPolicy.new(user, library_element)   }
  let(:library_element) { FactoryGirl.create :library_element }
  let(:user) { nil }

  context "for a visitor" do
    it { should deny(:create)  }
    it { should deny(:update)  }
    it { should deny(:destroy) }
  end

  context "for a random logged-in user" do
    let(:user) { FactoryGirl.create :user }
    it { should deny(:create)             }
    it { should deny(:update)             }
    it { should deny(:destroy)            }
  end

  context "for the template owning user" do
    let(:user) { library_element.library.user }
    it { should permit(:create)               }
    it { should permit(:update)               }
    it { should permit(:destroy)              }
  end
end
