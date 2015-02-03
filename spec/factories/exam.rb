FactoryGirl.define do
 factory :exam do |e|
    e.start_time    Time.now
    e.end_time      Time.now + 1.hours
    e.maximum_marks 100
    e.minimum_marks 30
    e.weightage     50
  end
end