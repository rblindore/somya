Fedena::Application.routes.draw do

  # A

    resources :application, only: :index do
      member do
        get :set_language
      end
    end

    resources :assessment_scores do
      collection do
        get :exam_fa_groups
        get :observation_groups
      end
    end

    resources :attendances do
      collection do
        get :daily_register
        get :subject_wise_register
        get :list_subject
      end
    end

    resources :attendance_reports do
      collection do
        get :advance_search
        get :mode
        get :subject
        get :show_mode
        get :year
        get :report
      end
    end
  # B

    resources :batches do
      collection do
        get :batches_ajax
        get :assign_tutor
        get :delete
        get :show
      end
      resources :exam_groups
      #batch.resources :additional_exam_groups
      resources :elective_groups, :as => :electives do
        post :new
      end
    end

    resources :batch_transfers, only: :index do
      collection do
        get :update_batch
        get :subject_transfer
        get :show_batch
        get :graduation
        post :graduation
        get :transfer
        patch :transfer
      end
    end
  # C

    resources :calendar, only: :index do
      collection do
        get :new_calendar
        get :show_holiday_event_tooltip
        get :event_delete
        get :show_event_tooltip
      end
    end

    resources :cce_exam_categories

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

    resources :cce_settings do
      collection do
        get :basic
        get :scholastic
        get :co_scholastic
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

    resources :class_designations, only: :index do
      collection do
        get :load_class_designations
        get :create_class_designation
        post :create_class_designation
        get :edit_class_designation
        get :delete_class_designation
        get :update_class_designation
        post :update_class_designation
      end
    end

    resources :class_timings, except: :show do
      collection do
        get :show_class_timing
      end
    end

    resources :configuration, only: :index do
      collection do
        get :settings
        post :settings
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
        get :delete
      end
    end
  # D
  # E
    resources :elective_groups do
      collection do
        get :new
        get :delete
      end
    end

    resources :employee_attendance do
      collection do
        get :employee_leave_reset_by_department
        get :add_leave_types
        get :report
        get :manual_reset
        get :add_leave_types
        post :add_leave_types
        get :edit_leave_types
        post :edit_leave_types
        get :delete_leave_types
        get :update_attendance_report
        get :emp_attendance
        get :leave_history
        get :employee_attendance_pdf
        get :leave_reset_settings
        post :leave_reset_settings
        get :employee_leave_reset_all
        get :employee_leave_reset_by_employee
        get :update_leave_history
        post :update_leave_history
        get :update_employee_leave_reset_all
        get :list_department_leave_reset
        get :update_department_leave_reset
        post :update_department_leave_reset
        get :employee_view_all
        get :employee_search_ajax
        get :employee_leave_details
        get :employee_wise_leave_reset
        get :employees_list
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
        post :admission1
        get :advanced_search
        get :advanced_search_pdf
        get :view_all
        get :payslip_approve
        get :add_category
        post :add_category
        get :add_position
        post :add_position
        get :add_department
        post :add_department
        get :add_grade
        post :add_grade
        get :add_bank_details
        post :add_bank_details
        get :add_additional_details
        post :add_additional_details
        get :edit_category
        post :edit_category
        get :delete_category
        get :edit_position
        post :edit_position
        get :delete_position
        get :edit_department
        post :edit_department
        get :delete_department
        get :edit_grade
        post :edit_grade
        get :delete_grade
        get :edit_bank_details
        post :edit_bank_details
        get :delete_bank_details
        get :edit_additional_details
        patch :edit_additional_details
        get :delete_additional_details
        get :update_positions
        get :update_employees
        get :admission2
        post :admission2
        get :admission3
        post :admission3
        get :admission3_1
        post :admission3_1
        get :edit_privilege
        post :edit_privilege
        get :admission4
        post :admission4
        get :select_department_employee
        get :rejected_payslip
        get :update_employee_select_list
        get :create_monthly_payslip
        post :create_monthly_payslip
        get :add_payslip_category
        post :add_payslip_category
        get :create_payslip_category
        post :create_payslip_category
        get :remove_new_paylist_category
        get :update_rejected_employee_list
        get :payslip_date_select
        get :view_rejected_payslip
        get :update_rejected_payslip
        get :edit_rejected_payslip
        post :edit_rejected_payslip
        get :profile
        get :remove
        get :change_reporting_manager
        post :change_reporting_manager
        get :edit1
        post :edit1
        get :profile_pdf
        get :change_to_former
        post :change_to_former
        get :delete
        post :department_payslip
        get :view_employee_payslip
        get :employee_individual_payslip_pdf
        get :update_reporting_manager_name
        get :select_reporting_manager
        get :assign_employee
        get :remove_employee
        get :employees_list
        get :search_ajax
        get :remove_subordinate_employee
        get :one_click_payslip_generation
        post :one_click_payslip_generation
        get :payslip_revert_date_select
        get :one_click_payslip_revert
        post :one_click_payslip_revert
      end
    end

    resources :employee_attendances do
      collection do
        get :show_dept
        get :delete_attendance
      end
    end

    resources :event do
      collection do
        get :index
        post :index
        get :show
        get :select_course
        get :confirm_event
        get :cancel_event
        get :course_event
        post :course_event
        get :remove_batch
        get :select_employee_department
        get :department_event
        post :department_event
        get :remove_department
        get :edit_event
        post :edit_event
      end
    end

    resources :exam, only: :index do
      collection do
        get :settings
        get :create_exam
        get :generate_reports
        post :generate_reports
        get :report_center
        get :previous_batch_exams
        get :update_batch
        get :list_inactive_batches
        get :generate_previous_reports
        post :generate_previous_reports
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
        get :grouping
        post :grouping
        get :list_inactive_exam_groups
        get :previous_exam_marks
        get :publish
        get :generated_report
        get :generated_report2
        get :generated_report3
        get :generated_report4
        get :combined_grouped_exam_report_pdf
        get :generated_report4_pdf
        get :student_transcript_pdf
        get :consolidated_exam_report
        get :generated_report_pdf
        get :consolidated_exam_report_pdf
        get :generated_report2_pdf
        get :student_subject_rank_pdf
        get :student_batch_rank_pdf
        get :student_course_rank_pdf
        get :student_course_rank
        get :student_school_rank_pdf
        get :student_attendance_rank_pdf
        get :select_report_type
        get :select_type
        post :student_transcript
        get :student_combined_report_pdf
        get :update_exam_form
        post :update_exam_form
      end
    end

    resources :exam_groups do
      collection do
        get :delete
      end

      resources :exams do
        member do
          post :save_scores
        end
      end
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
        get :final_archived_report_type
      end
    end
  # F

    resources :fa_criterias do
      resources :descriptive_indicators do
        resources :assessment_tools
      end
    end

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

    resources :finance, only: :index do
      collection do
        get :monthly_report
        get :transactions
        get :payslip_index
        get :asset_liability
        get :fee_collection
        get :fees_submission_index
        get :fees_student_structure_search
        get :automatic_transactions
        get :fees_create
        post :donation
        get :donors
        get :expense_create
        post :expense_create
        get :expense_list
        get :expense_list_update
        get :expense_list_pdf
        get :income_create
        post :income_create
        get :monthly_income
        get :income_list
        get :income_list_update
        get :income_list_pdf
        get :categories
        get :category_new
        post :category_create
        post :transaction_trigger_create
        get :update_monthly_report
        get :transaction_pdf
        get :salary_department
        get :donations_report
        get :fees_report
        get :approve_monthly_payslip
        get :one_click_approve
        get :one_click_approve_submit
        get :view_monthly_payslip
        post :view_monthly_payslip
        get :search_ajax
        get :create_liability
        get :liability_pdf
        get :view_liability
        post :create_asset
        get :view_asset
        get :asset_pdf
        get :master_fees
        get :master_category_new
        post :master_category_create
        get :show_master_categories_list
        get :fees_particulars_new
        post :fees_particulars_create
        get :fees_particulars_new2
        post :fees_particulars_create2
        post :additional_fees_create_form
        post :additional_fees_create
        get :additional_fees_list
        get :student_or_student_category
        get :fee_collection_new
        get :fee_collection_create
        post :fee_collection_create
        get :fee_collection_view
        get :fees_submission_batch
        get :update_fees_collection_dates
        get :load_fees_submission_batch
        post :update_ajax
        post :update_fine_ajax
        get :search_logic
        post :update_student_fine_ajax
        get :fees_submission_save
        post :fees_submission_save
        get :fees_index
        get :fees_student_structure_search_logic
        get :fees_defaulters
        post :update_batches
        post :update_fees_collection_dates_defaulters
        post :student_wise_fee_discount_create
        get :graph_for_transaction_comparison
        get :pay_fees_defaulters
        post :pay_fees_defaulters
        post :update_defaulters_fine_ajax
        get :compare_report
        get :fee_defaulters_pdf
        get :fees_defaulters_students
        get :report_compare
        get :month_date
        get :partial_payment
        post :graph_for_update_monthly_report
        post :graph_for_compare_monthly_report
        get :fee_discounts
        get :fee_discount_new
        get :load_discount_create_form
        get :load_batch_fee_category
        post :batch_wise_discount_create
        post :category_wise_fee_discount_create
        get :update_master_fee_category_list
        get :fixed_category_name
      end
      member do
        get :donation_receipt
        get :donation_edit
        post :donation_edit
        delete :donation_delete
        get :donation_receipt_pdf
        get :expense_edit
        post :expense_edit
        get :income_edit
        post :income_edit
        delete :delete_transaction
        get :income_details
        get :master_category_particulars
        delete :master_category_delete
        get :master_category_edit
        patch :master_category_update
        get :income_details_pdf
        delete :category_delete
        get :category_edit
        post :category_update
        put :transaction_trigger_edit
        put :transaction_trigger_update
        delete :transaction_trigger_delete
        get :salary_employee
        get :employee_payslip_monthly_report
        get :batch_fees_report
        get :student_fees_structure
        get :employee_payslip_approve
        get :employee_payslip_reject
        get :employee_payslip_accept_form
        get :employee_payslip_reject_form
        get :view_employee_payslip
        get :edit_liability
        put :update_liability
        get :delete_liability
        get :each_liability_view
        get :edit_asset
        post :update_asset
        delete :delete_asset
        get :each_asset_view
        get :master_category_edit
        get :master_category_particulars
        get :master_category_particulars_edit
        post :master_category_particulars_update
        delete :master_category_particulars_delete
        delete :master_category_delete
        get :additional_fees_edit
        put :additional_fees_update
        delete :additional_fees_delete
        get :add_particulars
        get :add_particulars_new
        post :add_particulars_create
        get :show_additional_fees_list
        get :additional_particulars
        get :add_particulars_edit
        post :add_particulars_update
        delete :add_particulars_delete
        get :fee_collection_batch_update
        get :fee_collection_dates_batch
        get :fee_collection_edit
        post :fee_collection_update
        delete :fee_collection_delete
        get :student_fee_receipt_pdf
        get :fees_student_dates
        get :fees_submission_student
        get :fees_structure_dates
        get :fees_structure_for_student
        get :student_fees_structure
        get :pdf_fee_structure
        get :load_discount_batch
        get :show_fee_discounts
        get :edit_fee_discount
        post :update_fee_discount
        delete :delete_fee_discount
        get :collection_details_view
      end
    end
  # G
    resources :grading_levels do
      collection do
        get :show_level
      end
    end
  # H
  # I
  # J
  # K
  # L
  # M
  # N
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
  # O
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
  # P
    resources :payroll, only: :index do
      collection do
        get :update_dependent_fields
        get :add_category
        post :add_category
      end
      member do
        get :edit_payroll_details
        post :edit_payroll_details
        get :manage_payroll
        post :manage_payroll
        delete :delete_category
        get :inactivate_category
        get :edit_category
        post :edit_category
        get :delete_category
      end
    end
  # R
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
  # S

    resources :students, only: [:index, :edit, :destroy, :show] do
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
        get :save_previous_subject
        post :save_previous_subject
        get :search_ajax
        get :advanced_search_pdf
        get :profile_pdf
        get :list_dob_year
        get :doa_greater_than_update
        get :doa_less_than_update
        get :list_doa_year
        get :add_additional_details
        get :generate_all_tc_pdf
        get :student_annual_overview
        get :exam_report
        get :update_student_result_for_examtype
        get :previous_years_marks_overview
        get :subject_wise_report
        get :doa_equal_to_update
        get :dob_less_than_update
        get :dob_equal_to_update
        get :dob_greater_than_update
        get :list_batches
      end
      member do
        get :profile
        get :profile_pdf
        get :reports
        get :guardians
        get :fees
        get :admission3_1
        post :admission3_1
        patch :edit
        get :admission2
        post :admission2
        get :admission3
        post :admission3
        get :admission4
        post :admission4
        get :previous_data
        post :previous_data
        get :edit_admission4
        post :edit_admission4
        get :previous_data_edit
        post :previous_data_edit
        get :previous_subject
        delete :delete_previous_subject
        get :change_field_priority
        get :edit_additional_details
        patch :edit_additional_details
        delete :delete_additional_details
        get :generate_tc_pdf
        post :edit
        get :edit_guardian
        post :edit_guardian
        get :academic_report
        get :academic_report_all
        get :change_to_former
        post :change_to_former
        delete :delete
        get :add_guardian
        post :add_guardian
        get :email
        post :email
        get :remove
        get :academic_pdf
        get :show_previous_details
        get :fee_details
        delete :del_guardian
        delete :category_delete
        get :category_edit
        post :category_edit
        get :category_update
        post :category_update
        get :electives
        get :assign_students
        get :assign_all_students
        get :unassign_students
        get :unassign_all_students
      end
    end


    resources :scheduled_jobs,:except => [:show]

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

    resources :student_attendance, only: :index do
      collection do
        get :advance_search
        get :student
        post :student
        get :month
      end
    end

    resources :subjects do
      collection do
        get :show_batch
        get :delete_subject
      end
    end
  # T
    resources :timetables, only: :index do
      collection do
        get :index
        get :work_allotment
        post :work_allotment
        get :new_timetable
        post :new_timetable
        get :edit_master
        get :view
        get :teachers_timetable
        get :timetable
        get :update_timetable_view
        get :update_teacher_tt
        get :update_timetable
        post :update_timetable
        get :destroy
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
  # U
    resources :users do
      collection do
        post :login
        get :forgot_password
        post :forgot_password
        get :dashboard
        get :all
        get :search_user_ajax
        get :list_user
        get :logout
        delete :logout
        get :list_employee_user
        get :list_student_user
        get :user_change_password
        post :user_change_password
        get :edit_privilege
        post :edit_privilege
        get :list_parent_user
        get :search_user_ajax
        get :create_user
        post :create_user
        get :delete
      end
      member do
        get :profile
        get :change_password
        post :change_password
        get :first_login_change_password
      end
    end

    get 'user/reset_password/:id', to: "users#reset_password"
    get 'users/set_new_password/:id', to: "users#set_new_password"
    post 'users/set_new_password/:id', to: "users#set_new_password"
  # V
  # W
    resources :weekday, only: [:index, :create] do
      collection do
        get :week
      end
    end
  # X
  # Y
  # Z




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
