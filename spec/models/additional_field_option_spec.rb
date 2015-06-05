require 'spec_helper'

describe AdditionalFieldOption, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to(:additional_field) }
  end
end
