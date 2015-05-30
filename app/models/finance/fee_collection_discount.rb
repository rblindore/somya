# == Schema Information
#
# Table name: fee_collection_discounts
#
#  id                        :integer          not null, primary key
#  type                      :string(255)
#  name                      :string(255)
#  receiver_id               :integer
#  finance_fee_collection_id :integer
#  discount                  :decimal(15, 2)
#  is_amount                 :boolean          default(FALSE)
#  created_at                :datetime
#  updated_at                :datetime
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

class FeeCollectionDiscount < ActiveRecord::Base

  def category_name
    c =StudentCategory.find(self.receiver_id)
    c.name unless c.nil?
  end

  def student_name
    s =Student.find(self.receiver_id)
    "#{s.first_name} (#{s.admission_no})" unless s.nil?
  end

end
