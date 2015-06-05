
FactoryGirl.define do
  factory :employee_user, class: User do |u|
    u.sequence(:username) { |n| "emp#{n}" }
    u.password            { |u1| "#{u1.username}123" }
    u.email               { |u1| "#{u1.username}@fedena.com" }
    u.first_name          'John'
    u.last_name           'Doe'
    u.role                'Employee'
  end

  factory :admin_user, class: User do |u|
    u.sequence(:username) { |n| "admin#{n}" }
    u.password { |u1| "#{u1.username}123" }
    u.first_name 'Fedena'
    u.sequence(:last_name) { |n| "Admin#{n}"}
    u.email { |u1| "#{u1.username}@fedena.com" }
    u.role 'Admin'
  end

  factory :user do |u|
    u.sequence(:username) { |n| "emp#{n}" }
    u.password            { |u1| "#{u1.username}123" }
    u.email               { |u1| "#{u1.username}@fedena.com" }
    u.first_name          'John'
    u.last_name           'Doe'
    u.role                'Employee'
  end

end

