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

class RemindersController < ApplicationController
  before_filter :login_required
  before_filter :protect_view_reminders, only: [:view,:mark_unread,:delete_by_recipient]
  before_filter :protect_sent_reminders, only: [:view_sent,:delete_by_sender]

  def index
    @user = current_user
    @reminders = Reminder.where(recipient: @user.id, is_deleted_by_recipient: false).order("created_at DESC").includes(:user).paginate(page: params[:page])
    @read_reminders = Reminder.where(recipient: @user.id, is_read: true, is_deleted_by_recipient: false).order("created_at DESC")
    @new_reminder_count = Reminder.where(recipient: @user.id, is_read: false, is_deleted_by_recipient: false)
    render layout: 'application'
  end

  def create_reminder
    @user = current_user
    @departments = EmployeeDepartment.find(:all)
    @new_reminder_count = Reminder.where(recipient: @user.id, is_read: false)
    unless params[:send_to].nil?
      recipients_array = params[:send_to].split(",").collect{ |s| s.to_i }
      @recipients = User.active.find(recipients_array)
    end
    if request.post?
      unless params[:reminder][:body].blank? || params[:recipients].blank?
        recipients_array = params[:recipients].split(",").collect{ |s| s.to_i }
        Delayed::Job.enqueue(DelayedReminderJob.new( sender_id: @user.id,
            recipient_ids: recipients_array,
            subject: params[:reminder][:subject],
            body: params[:reminder][:body] ))
        redirect_to create_reminder_reminders_path, notice: t('flash1')
      else
        redirect_to create_reminder_reminders_path, notice: "<b>ERROR:</b>#{t('flash6')}"
      end
    else
      render layout: 'application'
    end
  end

  def select_employee_department
    @user = current_user
    @departments = EmployeeDepartment.where(status: true)
    render partial: "select_employee_department", layout: 'application'
  end

  def select_users
    @user = current_user
    users = User.active.where(student: false)
    @to_users = users.map { |s| s.id unless s.nil? }
    render partial: :to_users, object: @to_users, layout: 'application'
  end

  def select_student_course
    @user = current_user
    @batches = Batch.active
    render :partial=> "select_student_course", layout: 'application'
  end

  def to_employees
    if params[:dept_id].blank?
      render :update do |page|
        page.replace_html "to_employees", text: "", layout: 'application'
      end
      return
    end
    department = EmployeeDepartment.find(params[:dept_id])
    employees = department.employees
    @to_users = employees.map { |s| s.user.id unless s.user.nil? }
    @to_users.delete nil
    render :update do |page|
      page.replace_html 'to_users', partial: 'to_users', object: @to_users, layout: 'application'
    end
  end

  def to_students
    if params[:batch_id] == ""
      render :update do |page|
        page.replace_html "to_user", text: "", layout: 'application'
      end
      return
    end

    batch = Batch.find(params[:batch_id])
    students = batch.students
    @to_users = students.map { |s| s.user.id unless s.user.nil? }
    @to_users.delete nil
    render :update do |page|
      page.replace_html 'to_users2', partial: 'to_users', object: @to_users, layout: 'application'
    end
  end

  def update_recipient_list
    if params[:recipients]
      recipients_array = params[:recipients].split(",").collect{ |s| s.to_i }
      @recipients = User.active.find(recipients_array)
      render :update do |page|
        page.replace_html 'recipient-list', partial: 'recipient_list', layout: 'application'
      end
    else
      redirect_to dashboard_users_path
    end
  end

  def sent
    @user = current_user
    @sent_reminders = Reminder.where(sender: @user.id, is_deleted_by_sender: false).order("created_at DESC").paginate(page: params[:page])
    @new_reminder_count = Reminder.where(recipient: @user.id, is_read: false)
    render layout: 'application'
  end

  def view_sent
    @sent_reminder = Reminder.find(params[:id])
  end

  def delete_by_sender
    @sent_reminder = Reminder.find(params[:id])
    Reminder.update(@sent_reminder.id, is_deleted_by_sender: true)
    redirect_to sent_reminder_path, notice: t('flash2')
  end

  def delete_by_recipient
    user = current_user
    employee = user.employee_record
    @reminder = Reminder.find(params[:id])
    Reminder.update(@reminder.id, is_deleted_by_recipient: true)
    redirect_to url_for(controller: controller_name, action: :index), notice: t('flash2')
  end

  def view
    user = current_user
    @new_reminder = Reminder.find(params[:id])
    Reminder.update(@new_reminder.id, is_read: true)
    @sender = @new_reminder.user

    if request.post?
      unless params[:reminder][:body].blank? || params[:recipients].blank?
        Reminder.create(sender: user.id, recipient: @sender.id, subject: params[:reminder][:subject], body: params[:reminder][:body], is_read: false, is_deleted_by_sender: false, is_deleted_by_recipient: false)
        redirect_to view_reminder_path(params[:id]), notice: t('flash3')
      else
        redirect_to view_reminder_path(params[:id]), notice: "<b>ERROR:</b>#{t('flash4')}"
      end
    else
      render layout: 'application'
    end
  end

  def mark_unread
    @reminder = Reminder.find(params[:id])
    Reminder.update(@reminder.id, is_read: false)
    redirect_to reminders_path, notice: t('flash5')
  end

  def pull_form
    @employee = Employee.find(params[:id])
    @manager = Employee.find(@employee.reporting_manager_id).user
    render :partial => "send_reminder", layout: 'application'
  end

  def send_reminder
    if params[:create_reminder]
      unless params[:create_reminder][:message].blank? || params[:create_reminder][:to].blank?
        Reminder.create(sender: params[:create_reminder][:from], recipient: params[:create_reminder][:to], subject: params[:create_reminder][:subject], body: params[:create_reminder][:message], is_read: false, is_deleted_by_sender: false, is_deleted_by_recipient: false)
        render(:update) do |page|
          page.replace_html 'error-msg', text: "<p class='flash-msg'>#{t('your_message_sent')}</p>", layout: 'application'
        end
      else
        render(:update) do |page|
          page.replace_html 'error-msg', text: "<p class='flash-msg'>#{t('enter_subject')}</p>", layout: 'application'
        end
      end
    else
      redirect_to controller: :reminders
    end
  end

  def reminder_actions
    @user = current_user
    message_ids = params[:message_ids]
    unless message_ids.nil?
      message_ids.each do |msg_id|
        msg = Reminder.find_by_id(msg_id)
        if params[:reminder][:action] == 'delete'
          Reminder.update(msg.id, :is_deleted_by_recipient => true, :is_read => true)
        elsif params[:reminder][:action] == 'read'
          Reminder.update(msg.id, :is_read => true)
        elsif params[:reminder][:action] == 'unread'
          Reminder.update(msg.id, :is_read => false)
        end
      end
    end
    @reminders = Reminder.where(recipient: @user.id, is_deleted_by_recipient: false).order("created_at DESC").paginate(page: params[:page])
    @new_reminder_count = Reminder.where(recipient: @user.id, is_read: false, is_deleted_by_recipient: false)

    redirect_to action: :index, page: params[:page]
  end

  def sent_reminder_delete
    @user = current_user
    message_ids = params[:message_ids]
    unless message_ids.nil?
      message_ids.each do |msg_id|
        msg = Reminder.find_by_id(msg_id)
        Reminder.update(msg.id, :is_deleted_by_sender => true)
      end
    end
    @sent_reminders = Reminder.where(sender: @user.id, is_deleted_by_sender: false).order("created_at DESC").paginate(page: params[:page])
    @new_reminder_count = Reminder.where(recipient: @user.id, is_read: false)

    redirect_to action: :sent_reminder, page: params[:page]
  end
end