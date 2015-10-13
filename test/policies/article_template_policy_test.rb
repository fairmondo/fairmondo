#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require_relative '../test_helper'

describe ArticleTemplatePolicy do
  include PunditMatcher

  subject { ArticleTemplatePolicy.new(user, article_template)   }
  let(:article_template) { FactoryGirl.create :article_template, :with_private_user }
  let(:user) { nil }

  describe 'for a visitor' do
    it { subject.must_deny(:new)     }
    it { subject.must_deny(:create)  }
    it { subject.must_deny(:edit)    }
    it { subject.must_deny(:update)  }
    it { subject.must_deny(:destroy) }
  end

  describe 'for a random logged-in user' do
    let(:user) { FactoryGirl.create :user }
    it { subject.must_deny(:new)                }
    it { subject.must_deny(:create)             }
    it { subject.must_deny(:edit)               }
    it { subject.must_deny(:update)             }
    it { subject.must_deny(:destroy)            }
  end

  describe 'for the template owning user' do
    let(:user) { article_template.seller }
    it { subject.must_permit(:new)           }
    it { subject.must_permit(:create)        }
    it { subject.must_permit(:edit)          }
    it { subject.must_permit(:update)        }
    it { subject.must_permit(:destroy)       }
  end
end
