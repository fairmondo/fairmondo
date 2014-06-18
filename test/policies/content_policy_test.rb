require_relative '../test_helper'

describe ContentPolicy do
  include PunditMatcher

  subject { ContentPolicy.new(user, content)   }
  let(:content) { FactoryGirl.create :content }
  let(:user) { nil }

  describe "for a visitor" do
    it { subject.must_permit(:show)      }
    it { subject.must_permit(:not_found) }
    it { subject.must_deny(:index)       }
    it { subject.must_deny(:new)         }
    it { subject.must_deny(:create)      }
    it { subject.must_deny(:edit)        }
    it { subject.must_deny(:update)      }
    it { subject.must_deny(:destroy)     }
  end

  describe "for a random logged-in user" do
    let(:user) { FactoryGirl.create :user }
    it { subject.must_permit(:show)      }
    it { subject.must_permit(:not_found) }
    it { subject.must_deny(:index)              }
    it { subject.must_deny(:new)                }
    it { subject.must_deny(:create)             }
    it { subject.must_deny(:edit)               }
    it { subject.must_deny(:update)             }
    it { subject.must_deny(:destroy)            }
  end

  describe "for an admin user" do
    let(:user) { FactoryGirl.create :admin_user }
    it { subject.must_permit(:show)      }
    it { subject.must_permit(:not_found) }
    it { subject.must_permit(:index) }
    it { subject.must_permit(:new)                    }
    it { subject.must_permit(:create)                 }
    it { subject.must_permit(:edit)                   }
    it { subject.must_permit(:update)                 }
    it { subject.must_permit(:destroy)                }
  end
end
