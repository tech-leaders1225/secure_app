module Concerns::Works::Manage
    
  def create_overwork
      time_change = time_change(params[:work][:day], params[:work][:endtime_plan])
      @work=select_user.works.find_by(day: params[:work][:day])
      if params[:work][:check_box]=="true"
          date_tomorrow=time_change.tomorrow - 9.hours
          @work.update_attributes(create_overwork_params)
          @work.update(endtime_plan: date_tomorrow)
      else
          @work.update_attributes(create_overwork_params)
          @work.update(endtime_plan: time_change-9.hours)
      end
      flash[:success] = "申請しました！"
      redirect_to  user_work_path(select_user,Date.today)
  end
  
  def update_overwork
      if params[:commit] == "確認"
          redirect_to user_work_path(User.find_by(id: params[:user_id]), params[:id], 
                                     authority: params[:authority], 
                                     modal: params[:modal], 
                                     work_day: params[:id],
                                     status: update_overwork_params)
          return
      end
      update_count = 0
      update_overwork_params.each do |id, item|
          work = Work.find(id)
          if item.fetch("check_box")=="true"
              work.update_attributes(over_check: item.fetch("over_check"))  
              update_count+=1
          end
      end
      flash[:success] = "#{update_overwork_params.keys.count}件中#{update_count}件、残業申請を更新しました!"
      #セレクトユーザーの編集した月��ージへ
      redirect_to  user_work_path(current_user,Date.today)
      
  end
  
  def create_monthwork
      if params[:work]&&!params[:work][:piyo].blank?
          @date = params[:work][:piyo].to_datetime
      else
          @date = params[:id].to_datetime
      end
      day = Date.new(@date.year,@date.month)
              current_user.works.find_by(day: day).update(month_check: params[:work][:month_check])
      flash[:success] = "申請しました!(１ヶ月分)"
      redirect_to  user_work_path(select_user,Date.today)
  end
  
  def update_monthwork
      if params[:commit] == "確認"
          redirect_to user_work_path(User.find_by(id: params[:user_id]), params[:id], 
                                     authority: params[:authority], 
                                     modal: params[:modal], 
                                     status: update_monthwork_params)
          return
      end
      update_count = 0
      update_monthwork_params.each do |id, item|
          work = Work.find(id)
          if item.fetch("check_box")=="true"
              work.update_attributes(month_check: item.fetch("month_check"))
              update_count+=1
          end
      end
      flash[:success] = "#{update_monthwork_params.keys.count}件中#{update_count}件、１ヶ月申請を更新しました!"
      #セレクトユーザーの編集した月ページへ
      redirect_to  user_work_path(current_user,Date.today)
  
  end
  
  def update_changework
      if params[:commit] == "確認"
          redirect_to user_work_path(User.find_by(id: params[:user_id]), params[:id], 
                                     authority: params[:authority], 
                                     modal: params[:modal], 
                                     work_day: params[:id],
                                     status: update_changework_params)
          return
      end
      update_count = 0
      update_changework_params.each do |id, item|
          work = Work.find_by(id: id)
          if item[:work_check] == "承認" && item.fetch("check_box") == "true"
              # 勤怠ログの作成
              WorkLog.create!(user_id: work.user_id, work_id: work.id, day: work.day, start_time: work.start_time, end_time: work.end_time,
                              starttime_change: work.starttime_change, endtime_change: work.endtime_change, work_check: work.work_check )
              # 勤怠変更申請（更新）
              work.update(work_check: item[:work_check], start_time: work.starttime_change, end_time: work.endtime_change)
              update_count+=1
          elsif item.fetch("check_box") == "true"
              work.update(item)
              work.update(check_box: "false")
              update_count+=1
          end
      end
      flash[:success] = "#{update_changework_params.keys.count}件中#{update_count}件、勤怠変更申請を更新しました!"
    #セレクトユーザーの編集した月ページへ
    redirect_to  user_work_path(current_user,Date.today)
  
  end
  
  
end