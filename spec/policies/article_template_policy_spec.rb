require 'spec_helper'

describe ArticleTemplatePolicy do
  include PunditMatcher

  subject { ArticleTemplatePolicy.new(user, article_template)   }
  let(:article_template) { FactoryGirl.create :article_template }
  let(:user) { nil }

  context "for a visitor" do
    it { should deny(:new)     }
    it { should deny(:create)  }
    it { should deny(:edit)    }
    it { should deny(:update)  }
    it { should deny(:destroy) }
  end

  context "for a random logged-in user" do
    let(:user) { FactoryGirl.create :user }
    it { should deny(:new)                }
    it { should deny(:create)             }
    it { should deny(:edit)               }
    it { should deny(:update)             }
    it { should deny(:destroy)            }
  end

  context "for the template owning user" do
    let(:user) { article_template.user }
    it { should permit(:new)           }
    it { should permit(:create)        }
    it { should permit(:edit)          }
    it { should permit(:update)        }
    it { should permit(:destroy)       }
  end
end