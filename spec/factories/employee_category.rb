FactoryGirl.define do
  factory :employee_category do |e|
    e.sequence(:name) { |n| "emp_category#{n}" }
    e.sequence(:prefix) { |n| "forad#{n}" }
  end
end