FactoryGirl.define do
  factory :exam_group do |e|
    e.sequence(:name) { |n| "Exam Group #{n}" }
    e.exam_date       Date.today
  end
end