class WorksController < ApplicationController
  
  before_action :logged_in_user, only: [:show, :edit, :create, :update, :work_log]
  before_action :aa, only: [:show, :edit, :create, :update]
  before_action :user_being, only: [:show, :edit, :create, :update]
  
  include WorksHelper
  include Concerns::Works::Manage
  
  def show
    @shops = User.order(:id)
    @work = Work.new
    @month_work = select_user.works.find_by(day: params[:id])
    @works = Work.where(checker: current_user.name)
    @user = User.find(params[:user_id])
    @id = params[:user_id]
    if params[:piyo]
      @date = params[:piyo].to_datetime
    else
      @date = params[:id].to_datetime
    end
    
    #表示する編集ページのユーザーの一月分のレコードが存在するか検証
    #レコードが存在しない場合は新規作成（create）
    days = (Date.new(@date.year,@date.month).all_month)
    if Work.where(user_id: @id, day: days).count < days.count
      days.each do |day|
        unless select_user.works.find_by(day: day)
          Work.create(user_id: select_user.id, day: day)
        end
      end
    end
    @works_list = Work.select_user(select_user.id).month_all(@date.all_month).order(:day)
    @work_array = []
    @works_list.each do |work|
    @work_array << work
    end
    n = 0
    @date.all_month.each do |date|
      if @work_array[n] == nil
        @work_array.insert(n, nil)
      elsif @work_array[n].day.strftime("%F") != date.strftime("%F")
        @work_array.insert(n, nil)
      end
      n = n+1
    end
    
  end
  
  def create
  work_name
    time = Time.new.strftime("%Y-%-m-%-d,%-H:%-M").to_time
    if @name == "出社"#出社ボタンが表示されている時
          # カラムに保存するデータは秒を０にする
      if Work.find_by(user_id: select_user.id, day: Time.current)
          #(update)出社ボタン押下の日付のレコードが存在したら、それを更新
          #秒以下を切り捨てるように更新設定
        Work.find_by(user_id: select_user.id, day: Time.current ).update(start_time: time)
                      select_user.update(working:"出社中")
        flash[:success] = "今日も一日頑張りましょう！"
      else
          #（creata）存在しなければ、新しくレコード作成
          #秒以下を切り捨てるように更新設定
        @work = Work.create(user_id: select_user.id, 
                            start_time: time,
                            day: Time.current)
        flash[:success] = "今日も一日頑張りましょう！"
      end
    elsif @name == "退社"#退社ボタンが表示されている時
      Work.find_by(user_id: select_user.id, day: Time.current ).update(end_time: time)
      select_user.update(working:"")
      flash[:success] = "お疲れ様でした！"
    elsif @name == "----"
    end
      #更新したワークのユーザーのトップページへ
    redirect_to user_work_path(select_user,Time.current)
  end
  
  def edit
      @user = User.find(params[:user_id])
      @id = params[:user_id] 
      @date = params[:piyo].to_datetime
      #表示する編集ページのユーザーの一月分のレコードが存在するか検証
      #レコードが存在しない場合は新規作成（create）
      # days = (Date.new(@date.year,@date.month).all_month)
      # if Work.where(user_id: @id, day: days).count < days.count
      #     days.each do |day|
      #         unless select_user.works.find_by(day: day)
      #             Work.create(user_id: select_user.id, day: day)
      #         end
      #     end
      # end
      @works_list = Work.select_user(@id).month_all(@date.all_month).order(:day)
      @work_array = []
      @works_list.each do |work|
          @work_array << work
      end
      
  end
  
  def update
      works_params.each do |id, item|
          
          work = Work.find_by(id: id)
          if item.fetch("start_time").present?
              start_time = Time.parse("#{work.day} #{item.fetch("start_time")}") - 9.hour
          else
              start_time = nil
          end
          if item.fetch("end_time").present?
              if item[:check_tomorrow] == "true"
                  end_time = Time.parse("#{work.day} #{item.fetch("end_time")}").tomorrow - 9.hour
              else
                  end_time = Time.parse("#{work.day} #{item.fetch("end_time")}") - 9.hour 
              end
          else
              end_time = nil
          end
          
          work.update(starttime_change: start_time,
                      endtime_change: end_time, 
                      note: item[:note], 
                      work_check: item[:work_check], 
                      check_tomorrow: item[:check_tomorrow])
      end
      flash[:success] = "勤怠変更を申請しました！"
      
  #セレクトユーザーの編集した月ページへ
  redirect_to  user_work_path(select_user,params[:piyo])
  end
  
  def redirect_to_show
    redirect_to user_work_path(current_user,Date.new(params[:select][:year].to_i, params[:select][:month].to_i))
  end
  
  
  
  
  
   private
  def works_params
      params.permit(works: [:start_time, :end_time, :note, :work_check, :check_tomorrow])[:works]
  end
  
  def create_overwork_params
      params.require(:work).permit(:endtime_plan, :work_content, :over_check, :day)
  end
  
  def update_monthwork_params
      params.permit(works: [:month_check, :check_box])[:works]
  end
  
  def update_overwork_params
      params.permit(works: [:over_check, :check_box])[:works]
  end
  
  def update_changework_params
      params.permit(works: [:work_check, :check_box])[:works]
  end
  
    def aa
      #paramsは文字列で帰ってくることを忘れない（数値にして比較）
      if current_user.id != params[:user_id].to_i && !current_user.admin?
        unless params[:authority]
          store_location
          flash[:danger] = "他のユーザー情報は閲覧できません。"
          redirect_to root_path
        end
      end
    end
    
    #存在するユーザーかどうか検証
    def user_being
      unless User.exists?(id: params[:user_id])
        flash[:danger] = "該当IDをもつユーザーは存在しません。"
        redirect_to root_path
      end
    end
    
    def correct_user
      unless current_user == User.find(params[:user_id])
        flash[:danger] = "他のユーザー情報は閲覧できません。"
        redirect_to root_path
      end
    end
  
end
