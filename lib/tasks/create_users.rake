# rake db:create_users
namespace :db do

  desc "Create Users."
  task :create_users  => :environment do
    user = User.find_or_initialize_by(username: 'fedena_admin')
    user.assign_attributes(username: 'fedena_admin', first_name: 'fedena', last_name: 'fedena', email: 'admin@fedena.com', admin: true, salt: 'fedena', password: '123456789', role: 'Admin')
    user.hashed_password = Digest::SHA1.hexdigest(user.salt + user.password)
    unless user.save
      puts user.errors.full_messages
    else
      puts "Admin user is created successfully", "username: #{user.username}", "password : '123456789'"
    end

    begin
      # Student User
      batch = Batch.create(name: 'Wild Life', start_date: Date.today, end_date: (Date.today + 1.month))
      course = Course.new(course_name: 'Photography', code: 'ph1')
      course.batches << batch
      course.save
      student = Student.new(first_name: 'Mitchel', last_name: 'Smith', admission_no: 'fedena_stud_1', admission_date: Date.today, date_of_birth: (Date.today - 20.years), batch: batch, gender: 'm')
      student_1 = Student.new(first_name: 'Jon', last_name: 'Smith', admission_no: 'fedena_stud_2', admission_date: Date.today, date_of_birth: (Date.today - 20.years), batch: batch, gender: 'm')
      set_user(student, false)
      set_user(student_1, true)
    rescue Exception => e
      puts e.message
    end

  end
end


def set_user(obj, is_student=true)
  if obj.save
    user = User.where(username: obj.admission_no).first
    user.hashed_password = (Digest::SHA1.hexdigest(user.salt + '123456789'))
    user.student = is_student
    user.save
    puts 'Student Crated successfully.', "username : #{obj.admission_no}", "password : 123456789"
  else
    puts obj.errors.full_messages
  end
end