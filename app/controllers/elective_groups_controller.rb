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

class ElectiveGroupsController < ApplicationController
  before_filter :pre_load_objects
  before_filter :login_required
  filter_access_to :all
  def index
    @elective_groups = ElectiveGroup.for_batch(@batch.id).includes(:subjects)
  end

  def new
    @elective_group = @batch.elective_groups.build
  end

  def create
    @elective_group = ElectiveGroup.new(elective_group_params)
    @elective_group.batch_id = @batch.id
    if @elective_group.save
      flash[:notice] = "#{t('elective_groups.flash1')}"
      redirect_to :action => :index, :batch_id => @batch.id 
    else
      render :action=>'new'
    end
  end

  def edit
    @elective_group = ElectiveGroup.find(params[:id])
  end

  def update
    @elective_group = ElectiveGroup.find(params[:id])
    if @elective_group.update_attributes(elective_group_params)
      flash[:notice] = "#{t('elective_groups.flash3')}"
      redirect_to :action => :index, :batch_id => @batch.id 
    else
      render 'edit'
    end
  end

  def delete
    @elective_group = ElectiveGroup.find(params[:id]).inactivate
    flash[:notice] =  "#{t('elective_groups.flash2')}"
    redirect_to :action => :index, :batch_id => @batch.id 
  end

  def show
    @electives = Subject.where("batch_id = ? and elective_group_id = ? and is_deleted = ? ", @batch.id,@elective_group.id, false)
  end

  private
  def pre_load_objects
    @batch = Batch.where(:id => params[:batch_id]).includes(:course).first
    @course = @batch.course
    @elective_group = ElectiveGroup.find(params[:id]) unless params[:id].nil?
  end
  
  def elective_group_params
    params.require(:elective_group).permit(:name, :batch_id, :is_deleted) if params[:elective_group]
  end
end
