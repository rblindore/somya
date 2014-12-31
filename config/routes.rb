Fedena::Application.routes.draw do

  resources :grading_levels do
    get :show
  end

  resources :ranking_levels do
    collection do
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

  resources :class_designations
  #map.resources :exam_reports, :collection => {:course_reports_index=>[:get,:post], :batch_reports_index=>[:get,:post]}

  resources :class_timings

  resources :subjects

  resources :attendances do
    collection do
      get :daily_register
      get :subject_wise_register
    end
  end

  resources :employee_attendances

  resources :attendance_reports

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

  ##feed 'courses/manage_course', :controller => 'courses' ,:action=>'manage_course'
  ##feed 'courses/manage_batches', :controller => 'courses' ,:action=>'manage_batches'

  resources :courses, :has_many => :batches do
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

  resources :timetables do
    resources :timetable_entries
  end

  resources :user do
    collection do
      post :login
      get :forgot_password
      get :dashboard
      get :all
      get :search_user_ajax
      get :list_user
    end
  end

  resources :news, only: :index do
    collection do
      get :all
      get :add
    end
  end
  resources :reminder, only: :index
  resources :student, only: :index do
    collection do
      get :admission1
      get :view_all
      get :advanced_search
      get :search_ajax
      get :list_students_by_course
    end
  end
  resources :exam, only: :index do
    collection do
      get :settings
      get :create_exam
      get :generate_reports
      get :report_center
    end
  end
  resources :timetable, only: :index
  resources :student_attendance, only: :index
  resources :configuration, only: :index
  resources :employee, only: :index do
    collection do
      get :hr
    end
  end

  resources :finance, only: :index

  root 'user#login' # :controller => 'user', :action => 'login'

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
