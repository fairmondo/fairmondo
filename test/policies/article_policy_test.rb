#
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
require_relative '../test_helper'

describe ArticlePolicy do
  include ::PunditMatcher
  subject { ArticlePolicy.new(user, article)  }
  let(:article) { FactoryGirl.create :preview_article }
  let(:cloned) { FactoryGirl.build :preview_article, original: original_article }
  let(:original_article) { FactoryGirl.create :locked_article, seller: user }
  let(:user) { nil }

  describe "for a visitor" do
    it { subject.must_permit(:index)           }

    it { subject.must_ultimately_deny(:new)    }
    it { subject.must_ultimately_deny(:create) }
    it { subject.must_deny(:edit)              }
    it { subject.must_deny(:update)            }
    it { subject.must_deny(:activate)          }
    it { subject.must_deny(:deactivate)        }
    it { subject.must_deny(:report)            }
    it { subject.must_deny(:destroy)           }
    # it { subject.must_deny(:show)              }

    describe "on an active article" do
      before { article.activate }
      it { subject.must_permit(:show)          }
      it { subject.must_permit(:report)        }
    end
  end

  describe "for a random logged-in user" do
    let(:user) { FactoryGirl.create :user }

    it { subject.must_permit(:index)           }
    it { subject.must_permit(:new)             }
    it { subject.must_permit(:create)          }
    it { subject.must_deny(:edit)              }
    it { subject.must_deny(:update)            }
    it { subject.must_deny(:activate)          }
    it { subject.must_deny(:deactivate)        }
    it { subject.must_ultimately_deny(:report) }
    it { subject.must_deny(:destroy)           }

    describe "on a cloned article" do
      it { ArticlePolicy.new(user, cloned).must_deny(:create) }
    end
  end

  describe "for the article owning user" do
    let(:user) { article.seller }

    describe "on all articles" do
      it { subject.must_permit(:index)      }
      it { subject.must_permit(:new)        }
      it { subject.must_permit(:create)     }

      it { subject.must_deny(:report)       }
    end

    describe "on an active article" do
      before { article.activate  }
      it { subject.must_permit(:deactivate) }
      it { subject.must_deny(:activate)     }
      it { subject.must_deny(:destroy)      }
    end

    describe "on an inactive article" do
      it { subject.must_deny(:deactivate)   }
      it { subject.must_permit(:activate)   }
      it { subject.must_permit(:destroy)    }
    end

    describe "on a locked article" do
      before do
        article.activate
        article.deactivate
      end
      it { subject.must_deny(:edit)        }
      it { subject.must_deny(:update)      }
      it { subject.must_permit(:destroy)   }
    end

    describe "on an unlocked article" do
      it { subject.must_permit(:edit)       }
      it { subject.must_permit(:update)     }
      it { subject.must_permit(:destroy)    }
    end

    describe "on a clone of a locked article" do
      let(:user) { cloned.seller }
      it { ArticlePolicy.new(user, cloned).must_permit(:create) }
    end

    describe "on a clone of an active article" do
      let(:original_article) { FactoryGirl.create :article, seller: user }
      it { ArticlePolicy.new(cloned.seller, cloned).must_deny(:create) }
    end
  end
end
