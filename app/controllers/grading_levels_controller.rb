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

class GradingLevelsController < ApplicationController
  before_filter :login_required
  filter_access_to :all
  skip_before_filter  :verify_authenticity_token
  def index
    @batches = Batch.active
    @grading_levels = GradingLevel.default
  end

  def new
    @grading_level = GradingLevel.new
    @batch = Batch.find params[:id] if request.xhr? and params[:id]
    if @batch.present?
      @credit = @batch.gpa_enabled? || @batch.cce_enabled?
    else
      @credit = Settings.cce_enabled? || Settings.get_config_value('CWA')=='1' || Settings.get_config_value('GPA')=='1'
    end
  end

  def create
    @grading_level = GradingLevel.new(grading_level_params)
    @batch = Batch.find params[:grading_level][:batch_id] unless params[:grading_level][:batch_id].empty?
      if @grading_level.save
        @grading_level.batch.nil? ?
          @grading_levels = GradingLevel.default :
          @grading_levels = GradingLevel.for_batch(@grading_level.batch_id)
      else
        @error = true
      end
  end

  def edit
    @grading_level = GradingLevel.find params[:id]
    @batch = Batch.find(@grading_level.batch_id) unless @grading_level.batch_id.nil?
    if @batch.present?
      @credit = @batch.gpa_enabled? || @batch.cce_enabled?
    else
      @credit = Settings.get_config_value('CCE')=='1' || Settings.get_config_value('CWA')=='1' || Settings.get_config_value('GPA')=='1'
    end
  end

  def update
    @grading_level = GradingLevel.find params[:id]
      if @grading_level.update_attributes(grading_level_params)
        if @grading_level.batch.nil?
          @grading_levels = GradingLevel.default
        else
          @batch = @grading_level.batch
          @grading_levels = GradingLevel.for_batch(@grading_level.batch_id)
        end
        #flash[:notice] = 'Grading level update successfully.'
      else
        @error = true
      end
  end

  def destroy
    @grading_level = GradingLevel.find params[:id]
    @grading_level.inactivate
    unless @grading_level.batch.nil?
      @batch = @grading_level.batch
    end
  end

  def show_level
    @batch = nil
    if params[:batch_id].blank?
      @grading_levels = GradingLevel.default
    else
      @grading_levels = GradingLevel.for_batch(params[:batch_id])
      @batch = Batch.find params[:batch_id] unless params[:batch_id].blank?
    end
    
  end
  
  def grading_level_params
    params.require(:grading_level).permit(:name, :batch_id, :min_score, :order, :is_deleted, :credit_points, :description) if params[:grading_level]
  end

end
