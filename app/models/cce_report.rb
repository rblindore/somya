# == Schema Information
#
# Table name: cce_reports
#
#  id              :integer          not null, primary key
#  observable_id   :integer
#  observable_type :string(255)
#  student_id      :integer
#  batch_id        :integer
#  grade_string    :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  exam_id         :integer
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
class CceReport < ActiveRecord::Base

  belongs_to    :batch
  belongs_to    :student
#  has_and_belongs_to_many   :exams
  belongs_to    :observable, polymorphic: true
  belongs_to    :exam

  scope :scholastic, ->{ where( observable_type: "FaCriteria")}
  scope :coscholastic, -> { where(observable_type: "Observation")}
end
