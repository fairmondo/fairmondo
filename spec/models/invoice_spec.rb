require 'spec_helper'

describe Invoice do
	let(:transaction) { FactoryGirl.create :single_transaction }
  let(:article) { transaction.article }
  let(:seller) { transaction.article.seller }
  let(:user) { FactoryGirl.create :user }

  describe "Use buy event on Transaction" do

  end
end
