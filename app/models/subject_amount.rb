# == Schema Information
#
# Table name: subject_amounts
#
#  id         :integer          not null, primary key
#  course_id  :integer
#  amount     :decimal(10, )
#  code       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class SubjectAmount < ActiveRecord::Base
  belongs_to :course

  validates_uniqueness_of :code, scope: :course_id
  validates_presence_of :course_id,:amount,:code
  validates_numericality_of :amount
end
