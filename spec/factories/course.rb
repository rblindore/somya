FactoryGirl.define do
  factory :course do |c|
    c.course_name  '1'
    c.section_name 'A'
    c.code         '1A'

    c.batches { |batches| [batches.association(:batch)] }
  end
end