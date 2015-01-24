# rake db:create_dummy_data
namespace :db do

  desc "Create dummy data."
  task :create_dummy_data  => :environment do
    user = User.last
    news =  News.create(title: "test", content: "test", author_id: user.id)
    comment = NewsComment.create(content: "test", news_id: 1, author_id: user.id)
    approved_comment = NewsComment.create(content: "test", news_id: 1, author_id: 3, is_approved: true)
  end
end