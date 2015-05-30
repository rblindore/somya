#Fedena
#Copyright 2011 Foradian Technologies Private Limited
#
#This product includes software developed at
#Project Fedena - http://www.projectfedena.org/
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

# == Schema Information
#
# Table name: guardians
#
#  id                   :integer          not null, primary key
#  ward_id              :integer
#  first_name           :string(255)
#  last_name            :string(255)
#  relation             :string(255)
#  email                :string(255)
#  office_phone1        :string(255)
#  office_phone2        :string(255)
#  mobile_phone         :string(255)
#  office_address_line1 :string(255)
#  office_address_line2 :string(255)
#  city                 :string(255)
#  state                :string(255)
#  country_id           :integer
#  dob                  :date
#  occupation           :string(255)
#  income               :string(255)
#  education            :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  user_id              :integer
#

class Guardian < ActiveRecord::Base
  belongs_to :country
  belongs_to :ward, class_name: 'Student'
  belongs_to :user
  has_many :immediate_guardian_of, class_name: 'Student', foreign_key: :immediate_contact_id

  validates_presence_of :first_name, :relation,:ward_id
  validates_format_of     :email, :with => /^[A-Z0-9._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i,   allow_blank: true, multiline: true, message: I18n.t('must_be_a_valid_email_address')
  before_destroy :immediate_contact_nil

  def validate
    errors.add(:dob, "#{I18n.t('cant_be_a_future_date')}.") if self.dob > Date.today unless self.dob.nil?
  end

  def is_immediate_contact?
    ward.immediate_contact_id == id
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def archive_guardian(archived_student)
    guardian_attributes = self.attributes
    guardian_attributes.delete "id"
    guardian_attributes.delete "user_id"
    guardian_attributes["ward_id"] = archived_student
    if ArchivedGuardian.create(guardian_attributes)
      self.user.soft_delete if self.user.present?
      self.destroy
    end
  end

  def create_guardian_user(student)
    user = User.new do |u|
      u.first_name = self.first_name
      u.last_name = self.last_name
      u.username = "p"+student.admission_no.to_s
      u.password = "p#{student.admission_no.to_s}123"
      u.role = 'Parent'
      u.email = ( email == '' or User.active.find_by_email(self.email) ) ? "" :self.email.to_s
    end
    self.update_attributes(:user_id => user.id) if user.save
  end



  def self.shift_user(student)
    self.where(:ward_id => student.id).each do |g|
      parent_user = g.user
      parent_user.soft_delete if parent_user.present? and (parent_user.is_deleted==false)
    end
    current_guardian =  student.immediate_contact
    current_guardian.create_guardian_user(student) if  current_guardian.present?
  end

  def immediate_contact_nil
    student = self.ward
    if student.present? and (student.immediate_contact_id==self.id)
      student.update_attributes(:immediate_contact_id=>nil)
    end
  end

end
