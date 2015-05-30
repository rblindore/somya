# == Schema Information
#
# Table name: student_additional_field_options
#
#  id                          :integer          not null, primary key
#  student_additional_field_id :integer
#  field_option                :string(255)
#  created_at                  :datetime
#  updated_at                  :datetime
#

class StudentAdditionalFieldOption < ActiveRecord::Base

  belongs_to :student_additional_field
end
