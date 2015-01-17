module UsersHelper

  # This method create a link ffor dashboard page.
  # This methiod required a link name.
  def create_link(name, options={})
    content_tag :div, (content_tag :p, name), class: 'button-label'
  end

  def admin_dashboard_links
    list = [
      {name: t('admission'), url: admission1_students_path, options: {class: :option_buttons, id: :admission_button, title: t('admission_link_title')}},
      {name: t('student_details'), url: students_path, options: {class: :option_buttons, id: :student_details_button, title: t('student_link_title')}},
      {name: t('manage_users'), url: users_path, options: { class: :option_buttons, id: :manage_users_button, title: t('user_link_title')}},
      {name: t('manage_news'), url: news_index_path, options: { class: :option_buttons, id: :manage_news_button, title: t('news_link_title') }},
      {name: t('examinations'), url: exam_index_path, options: { class: :option_buttons, id: :examinations_button, title: t('manage_examinations')}},
      {name: t('timetable_text'), url: timetable_index_path, options: { class: :option_buttons, id: :timetable_button, title: t('timetable_link_title') }},
      {name: t('attendance'), url: student_attendance_index_path, options: { class: :option_buttons, id: :student_attendance_button, title: t('attendance_link_title')}},
      {name: t('settings'), url: configuration_index_path, options: { class: :option_buttons, id: :settings_button, title: t('setting_link_title') }}
    ]
    list << {name: t('human_resources'), url: hr_employee_index_path, options: {class: :option_buttons, id: :hr_button, title: t('hr_link_title')}} if @config.include?('HR')
    list << {name: t('finance_text'), url: finance_index_path, options: {class: :option_buttons, id: :finance_button, title: t('finance_link_title')}} if @config.include?('Finance')
    list
  end

  def student_parent_links
    [
      {name: t('my_profile'), url: profile_student_path(@student.id), options: { class: :option_buttons, id: :student_details_button, title: t('view_your_profile')}},
      {name: t('campus_news'), url: news_index_path, options: { class: :option_buttons, id: :campus_news_button, title: t('news_link_title')}},
      {name: t('timetable_text'), url:  student_view_timetable_path(@student), options: { class: :option_buttons, id: :timetable_button, title: t('timetable_link_title') }},
      {name: t('academics'), url:  reports_student_path(@student.id), options: {class: :option_buttons, id: :academic_button, title: t('academic_reports')}}
    ]
  end

end