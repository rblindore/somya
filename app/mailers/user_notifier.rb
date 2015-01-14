class UserNotifier < ActionMailer::Base
  default from: "from@example.com"

  def forgot_password(user, current_url)
    @user = user
    @url =  "#{current_url}/user/reset_password/#{user.reset_password_code}"
    mail(to: user.email, from: admin_email(current_url), subject: "Reset Password")
  end

  protected

    def admin_email(current_url)
      User.active.find_by_username('admin').try(:email) || "noreply@#{get_domain(current_url)}"
    end

    def get_domain(current_url)
      url_parts = current_url.split("://").last.split('.')
      url_parts[(url_parts.length - 2) .. (url_parts.length - 1)].join('.')
    end
end
