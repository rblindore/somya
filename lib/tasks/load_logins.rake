# rake db:create_users
namespace :db do

  desc "Create Users."
  task :create_users  => :environment do
    [
      {username: 'fedena_admin', first_name: 'fedena', last_name: 'fedena', email: 'admin@fedena.com', admin: true, salt: 'fedena', password: '123456789', role: 'Admin' },
      {username: 'fedena_student', first_name: 'fedena', last_name: 'fedena', email: 'admin@fedena.com', student: true, salt: 'fedena', password: '123456789', role: 'Student' }
    ].each do |u|
      user = User.find_or_initialize_by(username: u[:username])
      user.assign_attributes(u)
      user.hashed_password = Digest::SHA1.hexdigest(user.salt + user.password)
      unless user.save
        puts user.errors.full_messages
      end

    end
  end
end
