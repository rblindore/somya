FactoryGirl.define do
  factory :employee_department do |e|
    e.sequence(:name) { |n| "emp_department#{n}" }
    e.sequence(:code) { |n| "forad#{n}" }
  end

  factory :general_department, class: EmployeeDepartment do |s|
    s.name  "Dep1"
    s.code   "forad"
  end
end