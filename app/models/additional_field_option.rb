# == Schema Information
#
# Table name: additional_field_options
#
#  id                  :integer          not null, primary key
#  additional_field_id :integer
#  field_option        :string(255)
#  school_id           :integer
#  created_at          :datetime
#  updated_at          :datetime
#

class AdditionalFieldOption < ActiveRecord::Base

  belongs_to :additional_field

end
