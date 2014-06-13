require 'spec_helper'

describe ContentPolicy do
  include PunditMatcher

  subject { ContentPolicy.new(user, content)   }
  let(:content) { FactoryGirl.create :content }
  let(:user) { nil }

  context "for a visitor" do
    it { should grant_permission(:show)      }
    it { should grant_permission(:not_found) }
    it { should deny(:index)       }
    it { should deny(:new)         }
    it { should deny(:create)      }
    it { should deny(:edit)        }
    it { should deny(:update)      }
    it { should deny(:destroy)     }
  end

  context "for a random logged-in user" do
    let(:user) { FactoryGirl.create :user }
    it { should grant_permission(:show)      }
    it { should grant_permission(:not_found) }
    it { should deny(:index)              }
    it { should deny(:new)                }
    it { should deny(:create)             }
    it { should deny(:edit)               }
    it { should deny(:update)             }
    it { should deny(:destroy)            }
  end

  context "for an admin user" do
    let(:user) { FactoryGirl.create :admin_user }
    it { should grant_permission(:show)      }
    it { should grant_permission(:not_found) }
    it { should grant_permission(:index) }
    it { should grant_permission(:new)                    }
    it { should grant_permission(:create)                 }
    it { should grant_permission(:edit)                   }
    it { should grant_permission(:update)                 }
    it { should grant_permission(:destroy)                }
  end
end
