require 'spec_helper'

describe Address do
  describe 'associations' do
    it { should belong_to :user }
    it { should belong_to :business_transaction }
  end

  describe 'attributes' do
    # fields
    it { should respond_to :title }
    it { should respond_to :first_name }
    it { should respond_to :last_name }
    it { should respond_to :address_line_1 }
    it { should respond_to :address_line_2 }
    it { should respond_to :zip }
    it { should respond_to :city }
    it { should respond_to :country }
    it { should respond_to :user_id }

    # validations
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
    it { should validate_presence_of :address_line_1 }
    it { should validate_presence_of :zip }
    it { should validate_presence_of :city }
    it { should validate_presence_of :country }
    it { should validate_presence_of :user_id }
  end
end
