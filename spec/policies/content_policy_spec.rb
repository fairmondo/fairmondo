require 'spec_helper'

describe ContentPolicy do
  include PunditMatcher

  subject { ContentPolicy.new(user, content)   }
  let(:content) { FactoryGirl.create :content }
  let(:user) { nil }

  context "for a visitor" do
    it { should permit(:show)      }
    it { should permit(:not_found) }
    it { should deny(:new)         }
    it { should deny(:create)      }
    it { should deny(:edit)        }
    it { should deny(:update)      }
    it { should deny(:destroy)     }
  end

  context "for a random logged-in user" do
    let(:user) { FactoryGirl.create :user }
    it { should deny(:new)                }
    it { should deny(:create)             }
    it { should deny(:edit)               }
    it { should deny(:update)             }
    it { should deny(:destroy)            }
  end

  context "for an admin user" do
    let(:user) { FactoryGirl.create :admin_user }
    it { should permit(:new)                    }
    it { should permit(:create)                 }
    it { should permit(:edit)                   }
    it { should permit(:update)                 }
    it { should permit(:destroy)                }
  end
end
