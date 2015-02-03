FactoryGirl.define do
  factory :batch do |b|
    b.name       '2010/11'
    b.start_date Date.today
    b.end_date   Date.today + 1.years
  end
end