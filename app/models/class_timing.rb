# == Schema Information
#
# Table name: class_timings
#
#  id         :integer          not null, primary key
#  batch_id   :integer
#  name       :string(255)
#  start_time :time
#  end_time   :time
#  is_break   :boolean
#  is_deleted :boolean          default(FALSE)
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

class ClassTiming < ActiveRecord::Base
  has_many :timetable_entries, dependent: :destroy
  belongs_to :batch

  validates_presence_of :name
  validates_uniqueness_of :name, scope: [:batch_id , :is_deleted]

  scope :for_batch, -> (b) { where( batch_id: b.to_i, is_deleted: false, is_break: false).order( 'start_time ASC' ) }
  scope :default, -> { where(batch_id: nil, is_break: false, is_deleted: false).order('start_time ASC')}
  scope :active_for_batch, -> (b) { where( batch_id: b.to_i, is_deleted: false).order( 'start_time ASC') }
  scope :active, -> { where( batch_id: nil, is_deleted: false).order('start_time ASC')}

  def validate
    errors.add(:end_time, I18n.t('should_be_later')) \
      if self.start_time > self.end_time \
      unless self.start_time.nil? or self.end_time.nil?


    self_check = self.new_record? ? "" : "id != #{self.id} && "

    start_overlap = !ClassTiming.where("#{self_check} start_time < ? && end_time > ? && is_deleted = ? && batch_id = ?", self.start_time, self.start_time, false, self.batch_id).blank?
    # start_overlap = !ClassTiming.where(self_check+"start_time < ? and end_time > ? and is_deleted = ? and batch_id #{self.batch_id.nil? ? 'is null' : '='+ self.batch_id.to_s}", self.start_time,self.start_time,false).first.nil?
    end_overlap = !ClassTiming.where("#{self_check} start_time < ? && end_time > ? && is_deleted = ? && batch_id = ? ", self.end_time, self.end_time, false, self.batch_id).blank?
    # end_overlap = !ClassTiming.find(:first, :conditions=>[self_check+"start_time < ? and end_time > ? and is_deleted = ? and batch_id #{self.batch_id.nil? ? 'is null' : '='+ self.batch_id.to_s}", self.end_time,self.end_time,false]).nil?
    between_overlap = !ClassTiming.where("#{self_check} start_time < ? && end_time > ? && is_deleted = ? && batch_id = ? ", self.end_time, self.start_time, false, self.batch_id).blank?
    # between_overlap = !ClassTiming.find(:first, :conditions=>[self_check+"start_time < ? and end_time > ? and is_deleted = ? and batch_id #{self.batch_id.nil? ? 'is null' : '='+ self.batch_id.to_s}",self.end_time, self.start_time,false]).nil?
    errors.add(:start_time, I18n.t('overlap_existing_class_timing')) if start_overlap
    errors.add(:end_time, I18n.t('overlap_existing_class_timing')) if end_overlap
    errors.add(:base, I18n.t('class_time_overlaps_with_existing')) if between_overlap
    errors.add(:start_time, I18n.t('is_same_as_end_time')) if self.start_time == self.end_time
  end
end
