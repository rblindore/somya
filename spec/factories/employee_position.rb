FactoryGirl.define do
  factory :employee_position do |e|
    e.sequence(:name) { |n| "employee_position #{n}" }
    e.status true
    e.employee_category

  end
end