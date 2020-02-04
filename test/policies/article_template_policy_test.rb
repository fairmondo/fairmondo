#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class ArticleTemplatePolicyTest < ActiveSupport::TestCase
  include PunditMatcher

  let(:article_template) { build :article_template, :with_private_user }
  let(:user) { nil }

  describe 'for a visitor' do
    it { refute_permit(user, article_template, :new)     }
    it { refute_permit(user, article_template, :create)  }
    it { refute_permit(user, article_template, :edit)    }
    it { refute_permit(user, article_template, :update)  }
    it { refute_permit(user, article_template, :destroy) }
  end

  describe 'for a random logged-in user' do
    let(:user) { build :user }
    it { refute_permit(user, article_template, :new)                }
    it { refute_permit(user, article_template, :create)             }
    it { refute_permit(user, article_template, :edit)               }
    it { refute_permit(user, article_template, :update)             }
    it { refute_permit(user, article_template, :destroy)            }
  end

  describe 'for the template owning user' do
    let(:user) { article_template.seller }
    it { assert_permit(user, article_template, :new)           }
    it { assert_permit(user, article_template, :create)        }
    it { assert_permit(user, article_template, :edit)          }
    it { assert_permit(user, article_template, :update)        }
    it { assert_permit(user, article_template, :destroy)       }
  end
end
