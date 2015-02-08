FactoryGirl.define do
  factory :employee_category do |e|
    e.sequence(:name) { |n| (0...18).map { (65 + Random.rand(26)).chr }.join }
    e.sequence(:prefix){ |n| (0...18).map { (65 + Random.rand(26)).chr }.join}
  end
end