#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class ArticlePolicyTest < ActiveSupport::TestCase
  include ::PunditMatcher
  subject { ArticlePolicy.new(user, article)  }
  let(:article) { create :preview_article }
  let(:cloned) { build :preview_article, original: original_article }
  let(:original_article) { create :locked_article, seller: user }
  let(:user) { nil }

  describe 'for a visitor' do
    it { assert_permit(user, article, :index)           }
    it { refute_permit(user, article, :new)    }
    it { refute_permit(user, article, :create) }
    it { refute_permit(user, article, :edit)              }
    it { refute_permit(user, article, :update)            }
    it { refute_permit(user, article, :activate)          }
    it { refute_permit(user, article, :deactivate)        }
    it { refute_permit(user, article, :report)            }
    it { refute_permit(user, article, :destroy)           }

    describe 'on an active article' do
      before do
        article.tos_accepted = '1'
        article.activate
      end
      it { assert_permit(user, article, :show)          }
      it { assert_permit(user, article, :report)        }
    end
  end

  describe 'for a random logged-in user' do
    let(:user) { create :user }

    it { assert_permit(user, article, :index)           }
    it { assert_permit(user, article, :new)             }
    it { assert_permit(user, article, :create)          }
    it { refute_permit(user, article, :edit)              }
    it { refute_permit(user, article, :update)            }
    it { refute_permit(user, article, :activate)          }
    it { refute_permit(user, article, :deactivate)        }
    it { refute_permit(user, article, :report) }
    it { refute_permit(user, article, :destroy)           }

    describe 'on a cloned article' do
      it { refute_permit(user, cloned,:create) }
    end
  end

  describe 'for the article owning user' do
    let(:user) { article.seller }

    describe 'on all articles' do
      it { assert_permit(user, article, :index)      }
      it { assert_permit(user, article, :new)        }
      it { assert_permit(user, article, :create)     }

      it { refute_permit(user, article, :report)       }
    end

    describe 'on an active article' do
      before  do
        article.tos_accepted = '1'
        article.activate
      end
      it { assert_permit(user, article, :deactivate) }
      it { assert_permit(user, article, :destroy)      }
      it { refute_permit(user, article, :activate)     }
    end

    describe 'on an inactive article' do
      it { refute_permit(user, article, :deactivate)   }
      it { assert_permit(user, article, :activate)   }
      it { assert_permit(user, article, :destroy)    }
    end

    describe 'on a locked article' do
      before do
        article.tos_accepted = '1'
        article.activate
        article.deactivate
      end
      it { refute_permit(user, article, :edit)        }
      it { refute_permit(user, article, :update)      }
      it { assert_permit(user, article, :destroy)   }
    end

    describe 'on an unlocked article' do
      it { assert_permit(user, article, :edit)       }
      it { assert_permit(user, article, :update)     }
      it { assert_permit(user, article, :destroy)    }
    end

    describe 'on a clone of a locked article' do
      let(:cloned) { build :preview_article, original: original_article, seller: original_article.seller }
      it { assert_permit(cloned.seller, cloned, :create) }
    end

    describe 'on a clone of an active article' do
      let(:original_article) { create :article, seller: user }
      it { refute_permit(cloned.seller, cloned, :create) }
    end
  end
end
