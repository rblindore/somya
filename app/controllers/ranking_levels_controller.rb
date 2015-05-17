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

class RankingLevelsController < ApplicationController

  before_filter :login_required
  filter_access_to :all
  skip_before_filter  :verify_authenticity_token
  def index
    #@courses = Course.active
    #@ranking_levels = RankingLevel.all(:order=> "priority ASC")
    #@ranking_level = RankingLevel.new
  end

  def load_ranking_levels
    unless params[:course_id].blank?
      @course = Course.find(params[:course_id])
      @ranking_levels = RankingLevel.where(:course_id => @course.id).order("priority ASC")
      @ranking_level = RankingLevel.new
    end
  end

  def create_ranking_level
    priority = 1
    @course = Course.find(params[:course_id])
    ranks = @course.ranking_levels.all
    unless ranks.empty?
      last_priority = ranks.map{|r| r.priority}.sort.last
      priority = last_priority + 1
    end
    @ranking_level = RankingLevel.new(raking_level_params)
    @ranking_level.priority = priority
    @ranking_level.course_id = @course.id
    if @ranking_level.save
      @ranking_level = RankingLevel.new
      @ranking_levels = RankingLevel.where( :course_id => @course.id).order("priority ASC")
      flash[:notice] = "#{t('ranking_levels.flash1')}"
    end
  end

  def edit_ranking_level
    @ranking_level = RankingLevel.find(params[:id])
    @course = @ranking_level.course
  end

  def update_ranking_level
    @ranking_level = RankingLevel.find(params[:id])
    @course = @ranking_level.course
    if @ranking_level.update_attributes(raking_level_params)
      @ranking_level = RankingLevel.new
      @ranking_levels = RankingLevel.where(:course_id => @course.id).order("priority ASC")
      @status = true
      
    end
  end
  
  def delete_ranking_level
    @ranking_level = RankingLevel.find(params[:id])
    @course = @ranking_level.course
    if @ranking_level.destroy
      @ranking_level = RankingLevel.new
      @ranking_levels = RankingLevel.where(:course_id => @course.id).order("priority ASC")
      @status = true
    end
  end

  def ranking_level_cancel
    @course = Course.find(params[:course_id])
    @ranking_levels = RankingLevel.where(:course_id => @course.id).order("priority ASC")
    @ranking_level = RankingLevel.new
  end

  def change_priority
    @ranking_level = RankingLevel.find(params[:id])
    @course = @ranking_level.course
    priority = @ranking_level.priority
    @ranking_levels = @course.ranking_levels.all.order("priority ASC").map{|b| b.priority.to_i}
    position = @ranking_levels.index(priority)
    if params[:order]=="up"
      prev_rank = RankingLevel.find_by_priority_and_course_id(@ranking_levels[position - 1],@course.id)
    else
      prev_rank = RankingLevel.find_by_priority_and_course_id(@ranking_levels[position + 1],@course.id)
    end
    @ranking_level.update_attributes(:priority=>prev_rank.priority)
    prev_rank.update_attributes(:priority=>priority.to_i)
    @ranking_level = RankingLevel.new
    @ranking_levels = RankingLevel.where(:course_id => @course.id).order("priority ASC")
 
  end
  
  def raking_level_params
    params.require(:ranking_level).permit(:name, :gpa, :marks, :subject_count, :priority, :full_course,:course_id , :subject_limit_type, :marks_limit_type) if params[:ranking_level]
  end

end
