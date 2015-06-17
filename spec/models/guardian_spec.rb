require 'spec_helper'

describe Guardian, type: :model do
  describe 'Attr accessor' do
    it { should have_attr_accessor(:password) }
  end

  describe 'Associations' do
    it { is_expected.to belong_to(:country) }
    it { is_expected.to belong_to(:ward) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:additional_field_options).dependent(:destroy) }
  end
end
