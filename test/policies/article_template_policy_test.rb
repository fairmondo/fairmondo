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
require 'test_helper'

describe ArticleTemplatePolicy do
  include PunditMatcher

  subject { ArticleTemplatePolicy.new(user, article_template)   }
  let(:article_template) { FactoryGirl.create :article_template, :with_private_user }
  let(:user) { nil }

  describe "for a visitor" do
    it { subject.must_deny(:new)     }
    it { subject.must_deny(:create)  }
    it { subject.must_deny(:edit)    }
    it { subject.must_deny(:update)  }
    it { subject.must_deny(:destroy) }
  end

  describe "for a random logged-in user" do
    let(:user) { FactoryGirl.create :user }
    it { subject.must_deny(:new)                }
    it { subject.must_deny(:create)             }
    it { subject.must_deny(:edit)               }
    it { subject.must_deny(:update)             }
    it { subject.must_deny(:destroy)            }
  end

  describe "for the template owning user" do
    let(:user) { article_template.seller }
    it { subject.must_permit(:new)           }
    it { subject.must_permit(:create)        }
    it { subject.must_permit(:edit)          }
    it { subject.must_permit(:update)        }
    it { subject.must_permit(:destroy)       }
  end
end
