#
# Farinopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Farinopoly.
#
# Farinopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Farinopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Farinopoly.  If not, see <http://www.gnu.org/licenses/>.
#
require 'spec_helper'

describe User do

  let(:user) { FactoryGirl::create(:user)}
  subject { user }

  it "has a valid Factory" do
    should be_valid
  end

  # relations

  it {should have_many(:articles).dependent(:destroy)}
  #it {should have_many(:bids).dependent(:destroy)}
  #it {should have_many(:invitations).dependent(:destroy)}

  it {should have_many(:article_templates).dependent(:destroy)}
  it {should have_many(:libraries).dependent(:destroy)}

  #it {should belong_to :invitor}


  # validations

  context "always" do
    it {should validate_presence_of :email}
  end

  context "on create" do
    subject { User.new }
    it {should validate_acceptance_of :privacy}
    it {should validate_acceptance_of :legal}
    it {should validate_acceptance_of :agecheck}
    it {should validate_presence_of :recaptcha}
  end

  context "on update" do
    it {should validate_presence_of :forename}
    it {should validate_presence_of :surname}
    it {should validate_presence_of :title}
    it {should validate_presence_of :country}
    it {should validate_presence_of :street}
    it {should validate_presence_of :city}
    it {should validate_presence_of :nickname}

    describe "zip code validation" do
      let(:user) { FactoryGirl.create(:german_user) }

      it {should validate_presence_of :zip}

      it "should validate the length" do
        user.zip = 1234
        user.should_not be_valid
      end

      it "should validate the format" do
        user.zip = "a1b2c"
        user.should_not be_valid
      end
    end
  end

  # validates :zip, :presence => true, :on => :update, :zip => true
  # validates_attachment_content_type :image,:content_type => ['image/jpeg', 'image/png', 'image/gif']
  # validates_attachment_size :image, :in => 0..5.megabytes


  it "returns correct fullname" do
    user.fullname.should eq "#{user.forename} #{user.surname}"
  end


  it "returns correct name" do
    user.name.should eq user.nickname
  end

end