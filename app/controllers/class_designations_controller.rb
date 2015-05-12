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

class ClassDesignationsController < ApplicationController
  before_filter :login_required
  filter_access_to :all

  def index
    #@class_designations = ClassDesignation.all
    #@class_designation = ClassDesignation.new
  end

  def load_class_designations
    unless params[:course_id].blank?
      @course = Course.find(params[:course_id])
      @class_designations = ClassDesignation.where(:course_id => @course.id)
      @class_designation = ClassDesignation.new
    end
  end

  def create_class_designation
    @course = Course.find(params[:course_id])
    @class_designation = ClassDesignation.new(class_designation_params)
    @class_designation.course_id = @course.id
    if @class_designation.save
      @class_designation = ClassDesignation.new
      @class_designations = @course.class_designations.all
      @status = true
    end
  end

  def edit_class_designation
    @class_designation = ClassDesignation.find(params[:id])
    @course = @class_designation.course
  end

  def update_class_designation
    @class_designation = ClassDesignation.find(params[:id])
    @course = @class_designation.course
    if @class_designation.update_attributes(class_designation_params)
      @class_designation = ClassDesignation.new
      @class_designations = @course.class_designations.all
      @status = true
    end
  end

  def delete_class_designation
    @class_designation = ClassDesignation.find(params[:id])
    @course = @class_designation.course
    @class_designation.destroy
    @class_designation = ClassDesignation.new
    @class_designations = @course.class_designations.all
    
    
  end
  
  def class_designation_params
    params.require(:class_designation).permit(:name,:cgpa,:marks, :course_id) if params[:class_designation]
  end

end
