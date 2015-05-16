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

class UsersController < ApplicationController

  before_filter :login_required, except: [:forgot_password, :login, :set_new_password, :reset_password,:first_login_change_password]
  before_filter :only_admin_allowed, only: [:edit, :create, :index, :edit_privilege, :user_change_password,:delete,:list_user,:all]
  before_filter :protect_user_data, only: [:profile, :user_change_password]
  before_filter :check_if_loggedin, only: [:login]
  #  filter_access_to :edit_privilege


  def all
    @users = User.active
    render layout: 'application'
  end

  def list_user

  end

  def list_employee_user
    emp_dept = params[:dept_id]
    @employee = Employee.where(employee_department_id: emp_dept).order('first_name ASC')
    @users = @employee.collect { |employee| employee.user}
    @users.delete(nil)
  end

  def list_student_user
    batch = params[:batch_id]
    @student = Student.where(batch_id: batch, is_active: true).order('first_name ASC')
    @users = @student.collect { |student| student.user}
    @users.delete(nil)
  end

  def list_parent_user
    batch = params[:batch_id]
    @guardian = Guardian.select('guardians.*').joins('INNER JOIN students ON students.id = guardians.ward_id').where('students.batch_id = ? AND students.is_active = ? ' , batch, true).order('first_name ASC')
    users = @guardian.collect { |g| g.user}
    users.compact!
    @users  = users.paginate(:page=>params[:page],:per_page=>20)
    render(:update) {|page| page.replace_html 'users', :partial=> 'users'}
  end

  def change_password

    if request.post?
      @user = current_user
      if User.authenticate?(@user.username, params[:user][:old_password])
        if params[:user][:new_password] == params[:user][:confirm_password]
          @user.password = params[:user][:new_password]
          if @user.update_attributes(password: @user.password, role: @user.role_name)
            redirect_to url_for(controller: controller_name, action: :dashboard), notice: t('user.flash9')
          else
            flash[:warn_notice] = "<p>#{@user.errors.full_messages}</p>"
            render layout: 'application'
          end
        else
          flash[:warn_notice] = "<p>#{t('user.flash10')}</p>"
          render layout: 'application'
        end
      else
        flash[:warn_notice] = "<p>#{t('user.flash11')}</p>"
        render layout: 'application'
      end
    else
      render layout: 'application'
    end
  end

  def user_change_password
    @user = User.active.find_by_username(params[:id])

    if request.post?
      if params[:user][:new_password]=='' and params[:user][:confirm_password]==''
        flash[:warn_notice]= "<p>#{t('user.flash6')}</p>"
      else
        if params[:user][:new_password] == params[:user][:confirm_password]
          @user.password = params[:user][:new_password]
          if @user.update_attributes(:password => @user.password,:role => @user.role_name)
            flash[:notice]= "#{t('user.flash7')}"
            redirect_to :action => "profile", :id=>@user.username
          else
            render :user_change_password
          end
        else
          flash[:warn_notice] =  "<p>#{t('user.flash10')}</p>"
        end
      end


    end
  end

  def create_user
    @config = Settings.available_modules

    @user = User.new(user_params)
    if request.post?
     @user.role = "Admin"
      if @user.save
        flash[:notice] = "#{t('user.flash17')}"
        redirect_to :controller => 'users', :action => 'edit', :id => @user.username
      else
        flash[:notice] = "#{t('user.flash16')}"
      end

    end
  end

  def delete
    @user = User.active.where("username = ? and admin = ? ", params[:id], true).first
    unless @user.nil?
      if @user.employee_record.nil?
        flash[:notice] = "#{t('user.flash12')}" if @user.destroy
      end
    end
    redirect_to :controller => 'users'
  end

  def dashboard
    @user = current_user
    @config = Settings.available_modules
    @employee = @user.employee_record if [t('admin'), t('employee_text')].include?(@user.role_name)
    if @user.student?
      @student = Student.where(admission_no:@user.username).first
    end
    if @user.parent?
      @student = Student.where(admission_no: @user.username[1..@user.username.length]).first
    end
    @first_time_login = Settings.get_config_value('FirstTimeLoginEnable')
    if  session[:user_id].present? and @first_time_login == "1" and @user.is_first_login != false
      redirect_to first_login_change_password_user_path(@user.username), notice: t('first_login_attempt')
    end
    render layout: 'dashboard'
  end


  def edit
    @user = User.active.find_by_username(params[:id])
    @current_user = current_user
     if request.post? and @user.update_attributes(params[:user])
       flash[:notice] = "#{t('flash13')}"
       redirect_to :controller => 'user', :action => 'profile', :id => @user.username
     end
  end
  
  def forgot_password
    #    flash[:notice]="You do not have permission to access forgot password!"
    #    redirect_to :action=>"login"
    @network_state = Settings.find_by_config_key("NetworkState")
    if request.post? and params[:reset_password]
      if user = User.active.find_by_username(params[:reset_password][:username])
        unless user.email.blank?
          user.reset_password_code = Digest::SHA1.hexdigest( "#{user.email}#{Time.now.to_s.split(//).sort_by {rand}.join}" )
          user.reset_password_code_until = 1.day.from_now
          user.role = user.role_name
          user.save(validate: false)
          url = "#{request.protocol}#{request.host_with_port}"
          UserNotifier.forgot_password(user,url).deliver
          redirect_to url_for(action: :index), notice: t('user.flash18')
        else
          flash[:notice] = t('user.flash20')
          render layout: 'forgotpw'
        end
      else
        flash[:notice] = "#{t('user.flash19')} #{params[:reset_password][:username]}"
        render layout: 'forgotpw'
      end
    else
      render layout: 'forgotpw'
    end
  end


  def login
    @institute = Settings.find_by_config_key("LogoName")
    available_login_authes = FedenaPlugin::AVAILABLE_MODULES.select{|m| m[:name].classify.constantize.respond_to?("login_hook")}
    selected_login_hook = available_login_authes.first if available_login_authes.count>=1
    if selected_login_hook
      authenticated_user = selected_login_hook[:name].classify.constantize.send("login_hook",self)
    else
      if request.post? and params[:user]
        @user = User.new(user_params)
        user = User.active.find_by_username @user.username
        if user.present? and User.authenticate?(@user.username, @user.password)
          authenticated_user = user
        end
      end
    end
    if authenticated_user.present?
      successful_user_login(authenticated_user) and return
    elsif authenticated_user.blank? and request.post?
      flash[:notice] = "#{t('login_error_message')}"
    end
    render layout: 'login'
  end

  def first_login_change_password
    @user = User.active.find_by_username(params[:id])
    @setting = Settings.get_config_value('FirstTimeLoginEnable')
    if @setting == "1" and @user.is_first_login != false
      if request.post?
        if params[:user][:new_password] == params[:user][:confirm_password]
          if @user.update_attributes(:password => params[:user][:confirm_password],:is_first_login => false)
            redirect_to url_for(controller: :users, action: :dashboard), notice: t('password_update')
          else
            render :first_login_change_password
          end
        else
          @user.errors.add('password','and confirm password doesnot match')
          render :first_login_change_password
        end
      end
    else
      redirect_to url_for(controller: :users, action: :dashboard), notice: t('not_applicable')
    end
  end

  def logout
    Rails.cache.delete("user_main_menu#{session[:user_id]}")
    Rails.cache.delete("user_autocomplete_menu#{session[:user_id]}")
    session[:user_id] = nil
    session[:language] = nil
    flash[:notice] = t('logged_out')
    available_login_authes = FedenaPlugin::AVAILABLE_MODULES.select{|m| m[:name].classify.constantize.respond_to?("logout_hook")}
    selected_logout_hook = available_login_authes.first if available_login_authes.count>=1
    if selected_logout_hook
      selected_logout_hook[:name].classify.constantize.send("logout_hook",self,"/")
    else
      redirect_to root_path, notice: 'Logout Successully.!'
    end
  end

  def profile
    @config = Settings.available_modules
    @current_user = current_user
    @username = @current_user.username if session[:user_id]
    @user = User.active.find_by_username(params[:id])
    unless @user.nil?
      @employee = Employee.find_by_employee_number(@user.username)
      @student = Student.find_by_admission_no(@user.username)
      @ward  = @user.parent_record if @user.parent
      render layout: 'application'
    else
      redirect_to dashboard_users_path, notice: t('flash14')
    end
  end

  def reset_password
    user = User.active.fwhere(reset_password_code: params[:id]).where.not(reset_password_code: nil).first
    if user
      if user.reset_password_code_until > Time.now
        redirect_to url_for(controller: :users, action: :set_new_password, id: user.reset_password_code)
      else
        redirect_to users_path, notice: t('flash1')
      end
    else
      redirect_to users_path, notice: t('flash2')
    end
  end

  def search_user_ajax
    unless params[:query].nil? or params[:query].empty? or params[:query] == ' '
      @user = User.active.where("(first_name LIKE ?  OR last_name LIKE ?
                        or username like ?)",
          "#{params[:query]}%","#{params[:query]}%",
          "#{params[:query]}",).order("first_name asc") unless params[:query].blank?
    else
      @user = nil
    end
    render :layout => false
  end

  def set_new_password
    if request.post?
      user = User.active.where(reset_password_code: params[:id]).where.not(reset_password_code: nil).first
      if user
        if params[:set_new_password][:new_password] === params[:set_new_password][:confirm_password]
          user.password = params[:set_new_password][:new_password]
          user.update_attributes(:password => user.password, :reset_password_code => nil, :reset_password_code_until => nil, :role => user.role_name)
          user.clear_menu_cache
          #User.update(user.id, :password => params[:set_new_password][:new_password],
          # :reset_password_code => nil, :reset_password_code_until => nil)
          flash[:notice] = t('flash3')
          redirect_to action: :index
        else
          flash[:notice] = t('user.flash4')
          redirect_to action: :set_new_password, id: user.reset_password_code
        end
      else
        flash[:notice] = t('flash5')
        redirect_to action: :index
      end
    end
    render layout: 'login'
  end

  def edit_privilege
    @user = User.active.find_by_username(params[:id])
    @finance = Settings.find_by_config_value("Finance")
    @sms_setting = SmsSetting.application_sms_status
    @hr = Settings.find_by_config_value("HR")
    @privilege_tags=PrivilegeTag.all.order("priority ASC")
    @user_privileges=@user.privileges
    if request.post?
      new_privileges = params[:user][:privilege_ids] if params[:user]
      new_privileges ||= []
      @user.privileges = Privilege.where(:id => new_privileges)
      @user.save
      @user.clear_menu_cache
      flash[:notice] = t('user.flash15')
      redirect_to :action => 'profile',:id => @user.username
    end
  end

  def header_link
    @user = current_user
    #@reminders = @users.check_reminders
    @config = Settings.available_modules
    @employee = Employee.find_by_employee_number(@user.username)
    @employee ||= Employee.first if current_user.admin?
    @student = Student.find_by_admission_no(@user.username)
    render :partial=>'header_link'
  end

  def index
    render layout: 'application'
  end


  private

    def successful_user_login(user)
      session[:user_id] = user.id
      flash[:notice] = "#{t('welcome')}, #{user.first_name} #{user.last_name}!"
      redirect_to session[:back_url] || {controller: :users, action: :dashboard}
    end

    def user_params
      params.require(:user).permit(:username, :password, :firstname, :lastname, :email) if params[:user]
    end
end

