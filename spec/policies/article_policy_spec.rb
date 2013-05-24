require 'spec_helper'

describe ArticlePolicy do
  include PunditMatcher
  subject { ArticlePolicy.new(user, article)  }
  let(:article) { FactoryGirl.create :preview_article }
  let(:user) { nil }

  context "for a visitor" do
    it { should permit(:index)           }

    it { should ultimately_deny(:new)    }
    it { should ultimately_deny(:create) }
    it { should deny(:edit)              }
    it { should deny(:update)            }
    it { should deny(:activate)          }
    it { should deny(:deactivate)        }
    it { should deny(:report)            }
    it { should deny(:destroy)           }

    context "on an active article" do
      before { article.activate     }
      it { should permit(:show)          }
    end

    context "on an inactive article" do
      before {     }
      it { should deny(:show)            }
    end
  end

  context "for a random logged-in user" do
    let(:user) { FactoryGirl.create :user }

    it { should permit(:index)           }
    it { should permit(:new)             }
    it { should permit(:create)          }
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
      it { should permit(:index)      }
      it { should permit(:new)        }
      it { should permit(:create)     }

      it { should deny(:report)       }
      it { should deny(:destroy)      }
    end

    context "on an active article" do
      before { article.activate  }
      it { should permit(:deactivate) }
      it { should deny(:activate)     }
    end

    context "on an inactive article" do
      before {  }
      it { should deny(:deactivate)   }
      it { should permit(:activate)   }
    end

    context "on a locked article" do
      before {
            article.activate
            article.deactivate
         }
      it { should deny(:edit)        }
      it { should deny(:update)      }
    end

    context "on an unlocked article" do
      it { should permit(:edit)       }
      it { should permit(:update)     }
    end
  end
end
