FactoryGirl.define do
  factory :employee_grade do |e|
    e.sequence(:name) { |n| (0...8).map { (65 + Random.rand(26)).chr }.join }
    e.sequence(:priority) { |n| Random.rand(1..9999) }
  end
end