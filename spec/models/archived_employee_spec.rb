require 'spec_helper'

describe ArchivedEmployee, type: :model do

  describe 'Associations' do
    [:employee_category, :employee_department, :employee_position, :employee_grade ].each do |field|
      it { is_expected.to belong_to(field) }
    end
    it { is_expected.to belong_to(:nationality).class_name('Country')}
    # it { is_expected.to have_many(:archived_employee_bank_details) }
    # it { is_expected.to have_many(:archived_employee_additional_details) }
  end

  describe 'callbacks' do
    it 'set stats false before save' do
      archived_employee = FactoryGirl.create(:archived_employee)
      expect(archived_employee.status).to eq(false)
    end
  end
end