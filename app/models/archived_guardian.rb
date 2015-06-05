# == Schema Information
#
# Table name: archived_guardians
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
#

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

class ArchivedGuardian < ActiveRecord::Base
  belongs_to :country
  belongs_to :ward, :class_name => 'ArchivedStudent'



  def full_name
    "#{first_name} #{last_name}"
  end

  def is_immediate_contact?
    ward.immediate_contact_id == id
  end
end
