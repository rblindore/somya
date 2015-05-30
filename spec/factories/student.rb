FactoryGirl.define do
  factory :student do |s|
    s.admission_no    1
    s.admission_date  Date.today
    s.date_of_birth   Date.today - 5.years
    s.first_name      'John'
    s.middle_name     'K'
    s.last_name       'Doe'
    s.address_line1   ''
    s.address_line2   ''
    s.batch_id        1
    s.gender          'm'
    s.country_id      76
    s.nationality_id  76
  end

  factory :ward, class: :student do |s|
  end
end