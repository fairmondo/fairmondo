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
require 'spec_helper'

describe ArticlePolicy do
  include PunditMatcher
  subject { ArticlePolicy.new(user, article)  }
  let(:article) { FactoryGirl.create :preview_article }
  let(:user) { nil }

  context "for a visitor" do
    it { should grant_permission(:index)           }

    it { should ultimately_deny(:new)    }
    it { should ultimately_deny(:create) }
    it { should deny(:edit)              }
    it { should deny(:update)            }
    it { should deny(:activate)          }
    it { should deny(:deactivate)        }
    it { should deny(:report)            }
    it { should deny(:destroy)           }
    # it { should deny(:show)              }

    context "on an active article" do
      before { article.activate          }
      it { should grant_permission(:show)          }
      it { should grant_permission(:report)            }
    end
  end

  context "for a random logged-in user" do
    let(:user) { FactoryGirl.create :user }

    it { should grant_permission(:index)           }
    it { should grant_permission(:new)             }
    it { should grant_permission(:create)          }
    it { should deny(:edit)              }
    it { should deny(:update)            }
    it { should deny(:activate)          }
    it { should deny(:deactivate)        }
    it { should ultimately_deny(:report) }
    it { should deny(:destroy)           }
  end

  context "for the article owning user" do
    let(:user) { article.seller       }

    context "on all articles" do
      it { should grant_permission(:index)      }
      it { should grant_permission(:new)        }
      it { should grant_permission(:create)     }

      it { should deny(:report)       }
    end

    context "on an active article" do
      before { article.activate  }
      it { should grant_permission(:deactivate) }
      it { should deny(:activate)     }
      it { should deny(:destroy)      }
    end

    context "on an inactive article" do
      it { should deny(:deactivate)   }
      it { should grant_permission(:activate)   }
      it { should grant_permission(:destroy)    }
    end

    context "on a locked article" do
      before do
        article.activate
        article.deactivate
      end
      it { should deny(:edit)        }
      it { should deny(:update)      }
      it { should grant_permission(:destroy)   }
    end

    context "on an unlocked article" do
      it { should grant_permission(:edit)       }
      it { should grant_permission(:update)     }
      it { should grant_permission(:destroy)      }
    end
  end
end
