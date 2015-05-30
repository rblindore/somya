# == Schema Information
#
# Table name: privilege_tags
#
#  id         :integer          not null, primary key
#  name_tag   :string(255)
#  priority   :integer
#  created_at :datetime
#  updated_at :datetime
#

class PrivilegeTag < ActiveRecord::Base
  has_many :privileges
  # attr_accessible :name_tag, :priority
end
