require 'spec_helper'

describe ElectiveGroup do

  describe 'Associations' do
    it { is_expected.to belong_to(:batch) }
    it { is_expected.to have_many(:subjects)}
  end

  describe 'validation' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:batch_id) }
  end
  # it "should create a new instance given valid attributes" do
  #   ElectiveGroup.create(:elective_group)
  # end
end
