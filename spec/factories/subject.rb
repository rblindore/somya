
FactoryGirl.define do
  factory :subject do |s|
    s.name               'Subject'
    s.code               'SUB'
    s.max_weekly_classes 8
  end

  factory :general_subject, class: Subject do |s|
    s.name  "Subject"
    s.code   "SUB1"
    s.batch_id           1
    s.max_weekly_classes
  end

end