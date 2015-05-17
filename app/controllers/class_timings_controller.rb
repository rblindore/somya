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

class ClassTimingsController < ApplicationController
  before_filter :login_required
  filter_access_to :all

  def index
    @batches = Batch.active
    @class_timings = ClassTiming.where(batch_id: nil, is_deleted: false).order('start_time ASC')
  end

  def new
    @class_timing = ClassTiming.new
    @batch = Batch.find params[:id] if request.xhr? and params[:id]
  end

  def create
    @class_timing = ClassTiming.new(class_timing_params)
    @batch = @class_timing.batch
      if @class_timing.save
        @class_timing.batch.nil? ?
          @class_timings = ClassTiming.where(batch_id: nil, is_deleted: false).order('start_time ASC') :
          @class_timings = ClassTiming.for_batch(@class_timing.batch_id)
        #  flash[:notice] = 'Class timing was successfully created.'
      else
        @error = true
      end
  end

  def edit
    @class_timing = ClassTiming.find(params[:id])
  end

  def update
    @class_timing = ClassTiming.find params[:id]
      if @class_timing.update_attributes(class_timing_params)
        @class_timings = (@class_timing.batch.nil? ?
          ClassTiming.where(batch_id: nil).order('start_time ASC') : ClassTiming.for_batch(@class_timing.batch_id))
        #     flash[:notice] = 'Class timing updated successfully.'
      else
        @error = true
      end
  end

  def show_class_timing
    @batch = nil
    if params[:batch_id].blank?
      @class_timings = ClassTiming.where(batch_id: nil, is_deleted: false)
    else
      @class_timings = ClassTiming.active_for_batch(params[:batch_id])
      @batch = Batch.find params[:batch_id] unless params[:batch_id] == ''
    end
  end

  def destroy
    @class_timing = ClassTiming.find params[:id]
    @class_timing.update_attribute(:is_deleted,true)
  end
  
  def class_timing_params
    params.require(:class_timing).permit(:batch_id, :name, :start_time, :end_time, :is_break, :is_deleted) if params[:class_timing]
  end

end
