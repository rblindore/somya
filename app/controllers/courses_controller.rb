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

class CoursesController < ApplicationController
  before_filter :login_required
  before_filter :find_course, :only => [:show, :edit, :update, :delete]
  filter_access_to :all

  def index
    @courses = Course.active
  end

  def new
    @course = Course.new
    @grade_types=Course.grading_types_as_options
    #    gpa = Settings.find_by_config_key("GPA").config_value
    #    if gpa == "1"
    #      @grade_types << "GPA"
    #    end
    #    cwa = Settings.find_by_config_key("CWA").config_value
    #    if cwa == "1"
    #      @grade_types << "CWA"
    #    end
  end

  def manage_course
    @courses = Course.active
  end

  def assign_subject_amount
    @course = Course.active.find(params[:id])
    @subjects = @course.batches.map(&:subjects).flatten.compact.map(&:code).compact.flatten.uniq
    @subject_amount = @course.subject_amounts.build
    @subject_amounts = @course.subject_amounts.reject{|sa| sa.new_record?}
    if request.post?
      code = params[:subject_amount][:code]
      @subject_amount = @course.subject_amounts.build(subject_amount_params)
      if @subject_amount.save
        @subject_amounts = @course.subject_amounts.to_a.reject{|sa| sa.new_record?}
        flash[:notice] = "Subject amount saved successfully"
        redirect_to assign_subject_amount_courses_path(:id => @course.id)
      else
        render :assign_subject_amount
      end
    end
  end

  def edit_subject_amount
    @subject_amount = SubjectAmount.find(params[:subject_amount_id])
    @course = @subject_amount.course
    @subjects = @course.batches.map(&:subjects).flatten.compact.map(&:code).compact.flatten.uniq
    if request.post?
      if @subject_amount.update_attributes(subject_amount_params)
        flash[:notice] = "Subject amount has been updated successfully"
        redirect_to assign_subject_amount_courses_path(:id => @subject_amount.course_id)
      else
        render :edit_subject_amount
      end
    end
  end

  def destroy_subject_amount
    subject_amount = SubjectAmount.find(params[:subject_amount_id])
    course_id = subject_amount.course_id
    subject_amount.destroy
    flash[:notice] = "Subject amount has been destroyed sucessfully"
    redirect_to assign_subject_amount_courses_path(:id => course_id)
  end

  def manage_batches

  end

  def grouped_batches
    @course = Course.find(params[:id])
    @batch_groups = @course.batch_groups
    @batches = @course.active_batches.reject{|b| GroupedBatch.exists?(:batch_id=>b.id)}
    @batch_group = BatchGroup.new
  end

  def create_batch_group
    params[:batch_group][:course_id] = params[:course_id] if params[:batch_group]
    @batch_group = BatchGroup.new(batch_group_params)
    @course = Course.find(params[:course_id])
    @batch_group.course_id = @course.id
    @error=false
    if params[:batch_ids].blank?
      @error=true
    end
    if @batch_group.save && @error==false
      @status = true
      batches = params[:batch_ids]
      batches.each do|batch|
        GroupedBatch.create(:batch_group_id=>@batch_group.id,:batch_id=>batch)
      end
      @batch_group = BatchGroup.new
      @batch_groups = @course.batch_groups
      @batches = @course.active_batches.to_a.reject{|b| GroupedBatch.exists?(:batch_id=>b.id)}
    else
      if params[:batch_ids].blank?
        @batch_group_errors =  "Atleast one batch must be selected."
      end
    end
  end

  def edit_batch_group
    @batch_group = BatchGroup.find(params[:id])
    @course = @batch_group.course
    @assigned_batches = @course.active_batches.reject{|b| (!GroupedBatch.exists?(:batch_id=>b.id,:batch_group_id=>@batch_group.id))}
    @batches = @course.active_batches.reject{|b| (GroupedBatch.exists?(:batch_id=>b.id))}
    @batches = @assigned_batches + @batches
  end

  def update_batch_group
    @batch_group = BatchGroup.find(params[:id])
    @course = @batch_group.course
    unless params[:batch_ids].blank?
      if @batch_group.update_attributes(batch_group_params)
     	@status = true
        @batch_group.grouped_batches.map{|b| b.destroy}
        batches = params[:batch_ids]
        batches.each do|batch|
          GroupedBatch.create(:batch_group_id=>@batch_group.id,:batch_id=>batch)
        end
        @batch_group = BatchGroup.new
        @batch_groups = @course.batch_groups
        @batches = @course.active_batches.to_a.reject{|b| GroupedBatch.exists?(:batch_id=>b.id)}
      end
    else
      @batch_group.errors.add(:base, "Atleat one Batch must be selected.")
    end
  end

  def delete_batch_group
    @batch_group = BatchGroup.find(params[:id])
    @course = @batch_group.course
    @batch_group.destroy
    @batch_group = BatchGroup.new
    @batch_groups = @course.batch_groups
    @batches = @course.active_batches.reject{|b| GroupedBatch.exists?(:batch_id=>b.id)}
  end

  def update_batch
    @batch = Batch.where("course_id = ? and is_deleted = ? and is_active = ?", params[:course_name],  false,  true )


  end

  def create
    params[:batch][:batches][:start_date] = Date.civil(*params[:start_date].sort.map(&:last).map(&:to_i)) if params[:batch]
    params[:batch][:batches][:end_date] = Date.civil(*params[:end_date].sort.map(&:last).map(&:to_i)) if params[:batch]
    @course = Course.new course_params
    @batch = Batch.new batch_params
    if @batch.save
      if @course.save
	@batch.update_attributes(:course_id => @course.id)
        flash[:notice] = "#{t('courses.flash1')}"
        redirect_to :action=>'manage_course'
      else
      @grade_types=Course.grading_types_as_options
      #      gpa = Settings.find_by_config_key("GPA").config_value
      #      if gpa == "1"
      #        @grade_types << "GPA"
      #      end
      #      cwa = Settings.find_by_config_key("CWA").config_value
      #      if cwa == "1"
      #        @grade_types << "CWA"
      #      end
      render 'new'
      end
    else
          @course.errors.add(:base, I18n.t('should_have_an_initial_batch'))
	  @batch.errors.full_messages.each do |msg| @course.errors.add(:base, msg) end
	  render 'new'
    end
  end

  def edit
    @grade_types=Course.grading_types_as_options
    #    @grade_types=[]
    #    gpa = Settings.find_by_config_key("GPA").config_value
    #    if gpa == "1"
    #      @grade_types << "GPA"
    #    end
    #    cwa = Settings.find_by_config_key("CWA").config_value
    #    if cwa == "1"
    #      @grade_types << "CWA"
    #    end
  end

  def update
    if @course.update_attributes(course_params)
      flash[:notice] = "#{t('courses.flash2')}"
      redirect_to :action=>'manage_course'
    else
      @grade_types=Course.grading_types_as_options
      render 'edit'
    end
  end

  def delete
    if @course.batches.active.empty?
      @course.inactivate
      flash[:notice]="#{t('courses.flash3')}"
      redirect_to :action=>'manage_course'
    else
      flash[:warn_notice]="<p>#{t('courses.flash4')}</p>"
      redirect_to :action=>'manage_course'
    end

  end

  def show
    @batches = @course.batches.active
  end

  private
  def find_course
    @course = Course.find params[:id]
  end
  
  def batch_group_params
    params.require(:batch_group).permit(:name, :course_id) if params[:batch_group]
  end
  
  def subject_amount_params
    params.require(:subject_amount).permit(:amount, :code) if params[:subject_amount]
  end
  
  def course_params
    params[:batch] = params[:course] if params[:course]
    params.require(:batch).permit(:course_name, :code, :section_name, :is_deleted, :grading_type) if params[:batch]
  end

  def batch_params
    params[:batches] = params[:batch][:batches] if params[:batch]
    params.require(:batches).permit(:course_id, :is_active, :is_deleted, :start_date, :end_date, :name) if params[:batches]
  end
end
