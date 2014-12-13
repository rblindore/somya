class PrivilegeTag < ActiveRecord::Base
  has_many :privileges
  # attr_accessible :name_tag, :priority
end
