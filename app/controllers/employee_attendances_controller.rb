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

class EmployeeAttendancesController < ApplicationController
  before_filter :login_required,:configuration_settings_for_hr
  filter_access_to :all
  def index
    @departments = EmployeeDepartment.where("status = true").order("name ASC")
  end

  def show_dept
    @dept = EmployeeDepartment.find(params[:dept_id])
    @employees = Employee.where(:employee_department_id => @dept.id)
    unless params[:next].nil?
      @today = params[:next].to_date
    else
      @today = Date.today
    end
    @start_date = @today.beginning_of_month
    @end_date = @today.end_of_month
  end

  def new
    @attendance = EmployeeAttendance.new
    @employee = Employee.find(params[:id2])
    @date = params[:id]
    @leave_types = EmployeeLeaveType.where(:status => true).order("name ASC")

  end

  def create
    @attendance = EmployeeAttendance.new(employee_attendance_params)
    @employee = Employee.find(params[:employee_attendance][:employee_id])
    @date = params[:employee_attendance][:attendance_date]
    @reset_count = EmployeeLeave.find_by_employee_id_and_employee_leave_type_id(@attendance.employee_id, @attendance.employee_leave_type_id)
    if @attendance.save
      leaves_taken = @reset_count.leave_taken
      if @attendance.is_half_day
        leave = leaves_taken.to_f+(0.5)
        @reset_count.update_attributes(:leave_taken => leave)
      else
        leave = leaves_taken.to_f+(1)
        @reset_count.update_attributes(:leave_taken => leave)
      end
    else
      @error = true
    end
  end

  def edit
    @attendance = EmployeeAttendance.find(params[:id])
    @employee = Employee.find(@attendance.employee_id)
    @leave_types = EmployeeLeaveType.where(:status => true).order("name ASC")
  end

  def update
    @attendance = EmployeeAttendance.find params[:id]
    @reset_count = EmployeeLeave.find_by_employee_id_and_employee_leave_type_id(@attendance.employee_id, @attendance.employee_leave_type_id)
    leaves_taken = @reset_count.leave_taken
    day_status = @attendance.is_half_day
    leave_type = EmployeeLeaveType.find_by_id(@attendance.employee_leave_type_id)
    if @attendance.is_half_day
      half_day = true
    else
      half_day = false
    end
    if @attendance.update_attributes(employee_attendance_params) || @attendance.save
      if @attendance.employee_leave_type_id == leave_type.id
          unless day_status == @attendance.is_half_day
            if half_day
              leave = leaves_taken.to_f+(0.5)
            else
              leave = leaves_taken.to_f-(0.5)
            end
            @reset_count.update_attributes(:leave_taken => leave)
          end
        else
          if half_day
            leave = leaves_taken.to_f-(0.5)
          else
            leave = leaves_taken.to_f-(1.0)
          end
          @reset_count.update_attributes(:leave_taken => leave)
          @new_reset_count = EmployeeLeave.find_by_employee_id_and_employee_leave_type_id(@attendance.employee_id, @attendance.employee_leave_type_id)
          leaves_taken = @new_reset_count.leave_taken
          if @attendance.is_half_day
            leave = leaves_taken.to_f+(0.5)
            @new_reset_count.update_attributes(:leave_taken => leave)
          else
            leave = leaves_taken.to_f+(1)
            @new_reset_count.update_attributes(:leave_taken => leave)
          end
        end
        
      else
	@error = true
      end
      @employee = Employee.find(@attendance.employee_id)
        @date = @attendance.attendance_date
  end

  def delete_attendance
    @attendance = EmployeeAttendance.find(params[:id])
    @reset_count = EmployeeLeave.find_by_employee_id_and_employee_leave_type_id(@attendance.employee_id, @attendance.employee_leave_type_id)
    leaves_taken = @reset_count.leave_taken
    if @attendance.is_half_day
      leave = leaves_taken.to_f-(0.5)
    else
      leave = leaves_taken.to_f-(1)
    end
    @attendance.delete
    @reset_count.update_attributes(:leave_taken => leave)
#     respond_to do |format|
      @employee = Employee.find(@attendance.employee_id)
      @date = @attendance.attendance_date
#       format.js {render :action => 'update'}
#     end
#       flash[:notice] = ""
  end
  
  def employee_attendance_params
    params.require(:employee_attendance).permit(:attendance_date, :employee_id, :employee_leave_type_id, :reason, :is_half_day) if params[:employee_attendance]
  end
end
