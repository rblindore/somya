name = (0...18).map { (65 + Random.rand(26)).chr }.join
FactoryGirl.define do
  factory :finance_fee_category do |e|
    e.sequence(:name) { |n| (0...18).map { (65 + Random.rand(26)).chr }.join }
    is_master true
    batch
  end
end