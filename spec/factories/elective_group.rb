FactoryGirl.define do
 factory :elective_group do |e|
    e.sequence(:name) { |n| (0...18).map { (65 + Random.rand(26)).chr }.join }
    batch
  end
end