require 'spec_helper'

describe User, type: :model do

  describe 'Attr accessor' do
    it { should have_attr_accessor(:password) }
  end

  # describe 'Associations' do
  #   it { is_expected.to have_many(:additional_field_options).dependent(:destroy) }
  # end

  # describe 'Validations' do
  #   it { is_expected.to validate_presence_of(:name) }
  #   it { should validate_uniqueness_of(:name).case_insensitive}
  #   it { should allow_value('test', 'aghsfdhga123 wasd').for(:name)}
  #   it { should_not allow_value('test!@@#').for(:name).with_message(I18n.t('must_contain_only_letters_numbers_space'))}
  #   it { should accept_nested_attributes_for(:additional_field_options).allow_destroy(true) }
  # end

end
