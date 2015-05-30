# == Schema Information
#
# Table name: fee_discounts
#
#  id                      :integer          not null, primary key
#  type                    :string(255)
#  name                    :string(255)
#  receiver_id             :integer
#  finance_fee_category_id :integer
#  discount                :decimal(15, 2)
#  is_amount               :boolean          default(FALSE)
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


class StudentCategoryFeeDiscount < FeeDiscount

  belongs_to :receiver, class_name: 'StudentCategory'
  validates_presence_of :receiver_id, message: I18n.t('student_category_cant_be_blank')

  validates_uniqueness_of :name, scope: [:finance_fee_category_id, :type]

  #validates_uniqueness_of :receiver_id, :scope=>[:type,:finance_fee_category_id],:message=>'Discount already exists for the student category'

  def total_payable
    payable = finance_fee_collection.fee_category.fee_particulars.map(&:amount).compact.flatten.sum
    payable
  end

  def discount
    if is_amount == false
      super
    elsif is_amount == true
      payable = total_payable
      percentage = (super.to_f / payable.to_f).to_f * 100
      percentage
    end
  end

  def category_name
    c =StudentCategory.where(self.receiver_id).first
    c.name unless c.nil?
  end


end
