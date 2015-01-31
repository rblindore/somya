Fedena::Application.routes.draw do

  resources :grading_levels do
    collection do
      get :show
    end
  end

  resources :application, only: :index do
    member do
      get :set_language
    end
  end

  resources :ranking_levels do
    collection do
      get :load_ranking_levels
      get :create_ranking_level
      post :create_ranking_level
      get :edit_ranking_level
      post :edit_ranking_level
      get :update_ranking_level
      post :update_ranking_level
      get :delete_ranking_level
      post :delete_ranking_level
      get :ranking_level_cancel
      post :ranking_level_cancel
      get :change_priority
      post :change_priority
    end
  end

  resources :class_designations, only: :index do
    get :load_class_designations, on: :collection
  end

  resources :exam_reports, only: :index do
    collection do
      get :archived_exam_wise_report
      post :archived_exam_wise_report
      get :batch_reports_index
      post :batch_reports_index
      get :list_inactivated_batches
      post :final_archived_report_type
      post :archived_batches_exam_report
    end
  end

  resources :class_timings, except: :show do
    collection do
      get :show
    end
  end

  resources :subjects do
    collection do
      get :show
    end
  end

  resources :attendances do
    collection do
      get :daily_register
      get :subject_wise_register
    end
  end

  resources :employee_attendance do
    collection do
      get :employee_leave_reset_by_department
      get :add_leave_types
      get :report
      get :manual_reset
    end
  end

  resources :employee_attendances do
    collection do
    end
  end

  resources :attendance_reports do
    collection do
      get :advance_search
      get :mode
    end
  end

  resources :cce_exam_categories

  resources :assessment_scores do
    collection do
      get :exam_fa_groups
      get :observation_groups
    end
  end

  resources :cce_settings do
    collection do
      get :basic
      get :scholastic
      get :co_scholastic
    end
  end

  resources :scheduled_jobs,:except => [:show]

  resources :fa_groups do
    collection do
      get :assign_fa_groups
      post :assign_fa_groups
      get :new_fa_criteria
      post :new_fa_criteria
      get :create_fa_criteria
      post :create_fa_criteria
      get :edit_fa_criteria
      post :edit_fa_criteria
      get :update_fa_criteria
      post :update_fa_criteria
      post :destroy_fa_criteria
      get :reorder
      post :reorder
    end
  end

  #  do |fa|
  #    fa.resources  :fa_criterias
  #  end

  resources :fa_criterias do
    resources :descriptive_indicators do
      resources :assessment_tools
    end
  end

  resources :observations do
    resources :descriptive_indicators do
      resources :assessment_tools
    end
  end

  resources :observation_groups, only: :index do
    member do
      get :new_observation
      post :new_observation
      get :create_observation
      post :create_observation
      get :edit_observation
      post :edit_observation
      get :update_observation
      post :update_observation
      post :destroy_observation
      get :reorder
      post :reorder
    end
    collection do
      get :assign_courses
      post :assign_courses
      get :set_observation_group
      post :set_observation_group
    end
  end

  resources :cce_weightages, only: :index do
    member do
      get :assign_courses
      post :assign_courses
    end
    collection do
      get :assign_weightages
      post :assign_weightages
    end
  end

  resources :cce_grade_sets do
    member do
      get :new_grade
      post :new_grade
      get :edit_grade
      post :edit_grade
      get :update_grade
      post :update_grade
      post :destroy_grade
    end
  end

  resources :batch_transfers, only: :index do
    collection do
      get :update_batch
    end
  end

  ##feed 'courses/manage_course', :controller => 'courses' ,:action=>'manage_course'
  ##feed 'courses/manage_batches', :controller => 'courses' ,:action=>'manage_batches'

  resources :courses do
    collection do
      get :grouped_batches
      post :grouped_batches
      get :create_batch_group
      post :create_batch_group
      get :edit_batch_group
      post :edit_batch_group
      get :update_batch_group
      post :update_batch_group
      get :delete_batch_group
      post :delete_batch_group
      get :assign_subject_amount
      post :assign_subject_amount
      get :edit_subject_amount
      post :edit_subject_amount
      get :destroy_subject_amount
      post :destroy_subject_amount
      get :manage_course
      get :manage_batches
      get :update_batch
    end
  end

  resources :batches do
    collection do
      get :batches_ajax
    end
    resources :exam_groups
    #batch.resources :additional_exam_groups
    resources :elective_groups, :as => :electives
  end

  resources :exam_groups do
    resources :exams do
      member do
        post :save_scores
      end
    end
  end

  #  map.resources :additional_exam_groups do |additional_exam_group|
  #    additional_exam_group.resources :additional_exams , :member => { :save_additional_scores => :post }
  #  end

  resources :users do
    collection do
      post :login
      get :forgot_password
      post :forgot_password
      get :dashboard
      get :all
      get :search_user_ajax
      get :list_user
      delete :logout
    end
    member do
      get :profile
      get :change_password
      get :first_login_change_password
    end
  end

  resources :news, only: [:index, :edit] do
    collection do
      get :all
      get :add
      post :add
    end
    member do
      get :view
      post :add_comment
      delete :delete
      delete :delete_comment
      post :edit
    end
  end

  resources :reminders, only: :index do
    collection do
      get :sent
      get :create_reminder
      get :reminder_actions
      post :reminder_actions
      post :sent_reminder_delete
      get :view_sent_reminder
      get :select_employee_department
      get :select_users
      get :select_student_course
      get :to_employees
      get :to_students
    end
    member do
      get :view
      post :view
      get :mark_unread
      get :pull_form
      get :view_sent
      delete :delete_by_sender
      delete :delete_by_recipient
    end
  end

  resources :students, only: :index do
    collection do
      get :admission1
      post :admission1
      get :view_all
      get :advanced_search
      get :search_ajax
      get :list_students_by_course
      get :categories
      post :categories
      get :add_additional_details
      post :add_additional_details
    end
    member do
      get :profile
      get :reports
      get :guardians
      get :fees
    end
  end

  resources :calendar, only: :index
  resources :event, only: :index

  resources :exam, only: :index do
    collection do
      get :settings
      get :create_exam
      get :generate_reports
      get :report_center
      get :previous_batch_exams
      get :update_batch
      get :list_inactive_batches
      get :generate_previous_reports
      get :list_batch_groups
      get :select_inactive_batches
      get :exam_wise_report
      get :subject_wise_report
      get :grouped_exam_report
      get :subject_rank
      get :batch_rank
      get :course_rank
      get :student_school_rank
      get :attendance_rank
      get :ranking_level_report
      get :transcript
      get :combined_report
      get :list_exam_types
      get :select_batch_group
      post :generated_report
      get :list_subjects
      post :generated_report2
      get :final_report_type
      post :generated_report4
      get :list_batch_subjects
      post :student_subject_rank
      post :student_batch_rank
      get :batch_groups
      post :student_course_rank
      post :student_attendance_rank
      get :select_mode
      post :student_ranking_level_report
      get :student_transcript
      post :student_transcript_exam
      get :load_levels
      post :student_combined_report
    end
  end

  resources :timetables, only: :index do
    collection do
      get :work_allotment
      get :new_timetable
      post :new_timetable
      get :edit_master
      get :view
      get :teachers_timetable
      get :timetable
      get :update_timetable_view
      get :update_teacher_tt
    end
    member do
      get :update_student_tt
    end
    member do
      get :student_view
    end
    resources :timetable_entries do
      collection do
        get :update_multiple_timetable_entries2
        get :new_entry
      end
    end
  end


  resources :student_attendance, only: :index do
    collection do
      get :advance_search
    end
  end

  resources :configuration, only: :index do
    collection do
      get :settings
      post :settings
    end
  end

  resources :employee, only: :index do
    collection do
      get :hr
      get :subject_assignment
      get :update_subjects
      get :select_department
      get :settings
      get :employee_management
      get :employee_attendance
      get :payslip
      get :search
      get :department_payslip
      get :admission1
      get :advanced_search
      get :view_all
      get :payslip_approve
    end
  end
  resources :sms, only: :index do
    collection do
      get :settings
      post :settings
      get :update_general_sms_settings
      post :update_general_sms_settings
      get :students
      get :batches
      get :employees
      get :departments
      get :all
      get :show_sms_messages
      get :list_students
      post :batches
      get :list_employees
    end
  end

  get 'scheduled_jobs/:job_object/:job_type', to: "scheduled_jobs#index" , as: :scheduled_task

  resources :finance, only: :index do
    collection do
      get :fees_index
      get :categories
      get :transactions
      get :donation
      get :automatic_transactions
      get :payslip_index
      get :asset_liability
      get :fee_collection
      get :fees_submission_batch
      get :fees_student_search
      get :expense_create
      get :expense_list
      get :income_create
      get :income_list
      get :monthly_report
      get :compare_report
      get :donors
      get :view_monthly_payslip
      get :asset
      get :view_asset
      get :liability
      get :view_liability
      get :master_fees
      get :fees_defaulters
      get :fees_student_structure_search
      get :fees_submission_index
      get :fees_create
      get :master_category_new
      get :fees_particulars_new
      get :fee_discounts
      post :master_category_create
    end
    member do
      get :show_master_categories_list
    end
  end
  resources :weekday, only: [:index, :create] do
    collection do
      get :week
    end
  end

  root 'users#login' # :controller => 'user', :action => 'login'

  ## map.fa_scores 'assessment_scores/exam/:exam_id/fa_group/:fa_group_id', :controller=>'assessment_scores',:action=>'fa_scores'
  ## map.observation_scores 'assessment_scores/batch/:batch_id/observation_group/:observation_group_id', :controller=>'assessment_scores',:action=>'observation_scores'
  ## map.scheduled_task 'scheduled_jobs/:job_object/:job_type',:controller => "scheduled_jobs",:action => "index"
  ## map.scheduled_task_object 'scheduled_jobs/:job_object',:controller => "scheduled_jobs",:action => "index"


  #map.connect 'parts/:number', :controller => 'inventory', :action => 'sho

  ## map.connect ':controller/:action/:id'
  ## map.connect ':controller/:action'
  ## map.connect ':controller/:action/:id/:id2'
  ## map.connect ':controller/:action/:id.:format'

end
