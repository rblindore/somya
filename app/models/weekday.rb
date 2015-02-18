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

class Weekday < ActiveRecord::Base

  belongs_to :batch
  has_many :timetable_entries , dependent: :destroy
  default_scope { order('weekday asc') }
  scope :default, -> { where(batch_id: nil, is_deleted: false)}
  scope :for_batch, -> (b) {  where(batch_id: b.to_i, is_deleted: false) }

  def self.weekday_by_day(batch_id)
    days={}
    weekdays = Weekday.where(batch_id: batch_id)
    if weekdays.empty?
      weekdays = Weekday.default
    end
    days = weekdays.group_by(&:day_of_week)
  end

  def deactivate
    self.update_attribute(:is_deleted,true)
  end

  def self.add_day(batch_id,day)
    unless batch_id == 0
      unless Weekday.where(batch_id: batch_id, day_of_week: day).blank?
        Weekday.where(batch_id: batch_id, day_of_week: day).first.update_attributes(is_deleted: false, day_of_week: day)
      else
        w = Weekday.new(day_of_week: day, weekday: day, batch_id: batch_id, is_deleted: false)
        w.save
      end
    else
      unless Weekday.where(batch_id: nil, day_of_week: day).blank?
        Weekday.where(batch_id: nil, day_of_week: day).first.update_attributes( is_deleted: false, day_of_week: day)
      else
        w = Weekday.new(day_of_week: day, weekday: day, is_deleted: false)
        w.save
      end
    end
  end
end
