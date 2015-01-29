#Fedena
#Copyright 2011 Foradian Technologies Private Limited
#
#This product includes software developed at
#Project Fedena - http://www.projectfedena.org/
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

class NewsController < ApplicationController
  before_filter :login_required
  filter_access_to :all

  def add
    @news = current_user.news.build(news_params)
    if request.post? and @news.save
      sms_setting = SmsSetting.new()
      if sms_setting.application_sms_active
        students = Student.where(is_sms_enabled: true).select(:phone2)
      end
      redirect_to view_news_path(@news), notice: t('news.flash1')
    else
      render layout: 'application'
    end
  end

  def add_comment
    @cmnt = current_user.news_comment.build(params[:comment])
    @cmnt.is_approved = true if @current_user.privileges.include?(Privilege.find_by_name('ManageNews')) || @current_user.admin?
    @config = Settings.find_by_config_key('EnableNewsCommentModeration')
    if @cmnt.save
      render layout: 'application'
    else
      redirect_to :back
    end
  end

  def all
    @news = News.paginate page: params[:page]
    render layout: 'application'
  end

  def delete
    @news = News.find(params[:id]).destroy
    redirect_to news_index_path, notice: t('news.flash2')
  end

  def delete_comment
    @comment = NewsComment.find(params[:id])
    @comment.destroy
  end

  def edit
    @news = News.find(params[:id])
    if request.post? and @news.update_attributes(news_params)
      redirect_to view_news_path(@news), notice: t('news.flash3')
    else
      render layout: 'application'
    end
  end

  def index
    @current_user = current_user
    @news = []
    if request.get?
      @news = News.where("title LIKE ?", "%#{params[:query]}%") unless params[:query].blank?
    end
    render layout: 'application'
  end

  def search_news_ajax
    @news = nil
    conditions = ["title LIKE ?", "%#{params[:query]}%"]
    @news = News.where(conditions) unless params[:query].blank?
    render :layout => false
  end

  def view
    @current_user = current_user
    @news = News.find(params[:id])
    @comments = @news.comments
    @is_moderator = @current_user.privileges.include?(Privilege.find_by_name('ManageNews')) || @current_user.admin?
    @config = Settings.find_by_config_key('EnableNewsCommentModeration')
    render layout: 'application'
  end

  def comment_approved
    @comment = NewsComment.find(params[:id])
    status=@comment.is_approved ? false : true
    @comment.update_attributes(:is_approved=>status)
    render :update do |page|
      page.reload
    end
  end

  private

    # this method permist rge news attributes.
    def news_params
      params.require(:news).permit(:title, :content)
    end
end
